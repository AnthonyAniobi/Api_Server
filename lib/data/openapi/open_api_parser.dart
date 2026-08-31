import 'package:api_server/data/models/api_endpoint.dart';
import 'package:api_server/data/openapi/schema_example_generator.dart';

/// Parses an OpenAPI (Swagger) document into mock [ApiEndpoint]s, one per
/// path + HTTP method operation.
class OpenApiParser {
  OpenApiParser._();

  static const List<String> _httpMethods = [
    'get',
    'post',
    'put',
    'patch',
    'delete',
  ];

  static List<ApiEndpoint> parse(Map spec) {
    final paths = spec['paths'];
    if (paths is! Map) return [];

    final endpoints = <ApiEndpoint>[];
    paths.forEach((path, pathItem) {
      if (pathItem is! Map) return;
      for (final method in _httpMethods) {
        final operation = pathItem[method];
        if (operation is! Map) continue;
        endpoints.add(_toEndpoint(
          path: path.toString(),
          method: method,
          operation: operation,
          rootSpec: spec,
        ));
      }
    });
    return endpoints;
  }

  /// Recursively converts a tree that may contain `YamlMap`/`YamlList`
  /// nodes (as produced by `package:yaml`) into plain `Map`/`List`, so the
  /// rest of the pipeline can treat JSON- and YAML-sourced specs the same.
  static dynamic deepConvert(dynamic node) {
    if (node is Map) {
      return node.map((key, value) => MapEntry(key.toString(), deepConvert(value)));
    }
    if (node is Iterable) {
      return node.map(deepConvert).toList();
    }
    return node;
  }

  static ApiEndpoint _toEndpoint({
    required String path,
    required String method,
    required Map operation,
    required Map rootSpec,
  }) {
    return ApiEndpoint(
      title: _titleFor(path: path, method: method, operation: operation),
      url: path,
      type: method.toUpperCase(),
      headers: _extractHeaders(operation, rootSpec),
      requestBody: _asMap(_exampleFromContent(operation['requestBody'] is Map
          ? (operation['requestBody'] as Map)['content']
          : null, rootSpec)),
      result: _asMap(_extractResponseExample(operation, rootSpec, success: true)),
      errorResult:
          _asMap(_extractResponseExample(operation, rootSpec, success: false)),
    );
  }

  static String _titleFor({
    required String path,
    required String method,
    required Map operation,
  }) {
    final summary = operation['summary'];
    if (summary is String && summary.trim().isNotEmpty) return summary.trim();
    final operationId = operation['operationId'];
    if (operationId is String && operationId.trim().isNotEmpty) {
      return operationId.trim();
    }
    return '${method.toUpperCase()} $path';
  }

  static Map _extractHeaders(Map operation, Map rootSpec) {
    final parameters = operation['parameters'];
    if (parameters is! List) return {};

    final headers = <String, dynamic>{};
    for (final param in parameters) {
      if (param is! Map || param['in'] != 'header') continue;
      final name = param['name'];
      if (name == null) continue;

      dynamic example = param['example'];
      final schema = param['schema'];
      if (example == null && schema is Map) {
        example = SchemaExampleGenerator.generate(schema, rootSpec);
      }
      headers[name.toString()] = example ?? '';
    }
    return headers;
  }

  static dynamic _extractResponseExample(
    Map operation,
    Map rootSpec, {
    required bool success,
  }) {
    final responses = operation['responses'];
    if (responses is! Map) return {};

    MapEntry? match;
    for (final entry in responses.entries) {
      final code = entry.key.toString();
      final isSuccessCode = code.startsWith('2');
      final isErrorCode = code.startsWith('4') || code.startsWith('5');
      if (success && isSuccessCode) {
        match = entry;
        break;
      }
      if (!success && isErrorCode) {
        match = entry;
        break;
      }
    }
    // Error branch falls back to the `default` response when no explicit
    // 4xx/5xx is documented.
    if (match == null && !success && responses['default'] is Map) {
      match = MapEntry('default', responses['default']);
    }
    if (match == null) return {};

    final response = match.value;
    if (response is! Map) return {};
    return _exampleFromContent(response['content'], rootSpec);
  }

  static dynamic _exampleFromContent(dynamic content, Map rootSpec) {
    if (content is! Map || content.isEmpty) return null;

    final mediaType =
        content['application/json'] is Map ? content['application/json'] : content.values.first;
    if (mediaType is! Map) return null;

    if (mediaType.containsKey('example')) return mediaType['example'];
    final examples = mediaType['examples'];
    if (examples is Map && examples.isNotEmpty) {
      final first = examples.values.first;
      if (first is Map && first.containsKey('value')) return first['value'];
      return first;
    }
    final schema = mediaType['schema'];
    if (schema is Map) return SchemaExampleGenerator.generate(schema, rootSpec);
    return null;
  }

  static Map _asMap(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : {};
}
