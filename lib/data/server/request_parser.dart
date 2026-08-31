import 'dart:convert';
import 'dart:io';

import 'package:api_server/data/models/api_endpoint.dart';

class RequestParser {
  final List<ApiEndpoint> endpoints;

  // local variables
  final Map _notFound = {'status': 'error', 'message': 'endpoint not found'};

  RequestParser({required this.endpoints});

  void parse(HttpRequest request) {
    endpoints.sort(((a, b) => a.url.compareTo(b.url)));

    for (ApiEndpoint ePoint in endpoints) {
      if (_matchesPath(ePoint.url, request.uri.path) &&
          ePoint.type == request.method) {
        request.response.write(jsonEncode(ePoint.result));
        return;
      }
    }
    request.response.write(jsonEncode(_notFound));
  }

  /// Matches an endpoint url against an incoming request path, treating
  /// `{param}` segments (as used in OpenAPI paths, e.g. `/users/{id}`) as
  /// wildcards that match any single path segment.
  bool _matchesPath(String endpointUrl, String requestPath) {
    final endpointSegments = _segments(endpointUrl);
    final requestSegments = _segments(requestPath);

    if (endpointSegments.length != requestSegments.length) {
      return false;
    }

    for (var i = 0; i < endpointSegments.length; i++) {
      final endpointSegment = endpointSegments[i];
      final isWildcard =
          endpointSegment.startsWith('{') && endpointSegment.endsWith('}');
      if (!isWildcard && endpointSegment != requestSegments[i]) {
        return false;
      }
    }
    return true;
  }

  List<String> _segments(String path) =>
      path.split('/').where((segment) => segment.isNotEmpty).toList();
}
