/// Generates a representative example JSON value from a JSON Schema
/// fragment (as embedded in an OpenAPI document), resolving local `$ref`
/// pointers (e.g. `#/components/schemas/Pet`) against the full spec.
class SchemaExampleGenerator {
  SchemaExampleGenerator._();

  static const int _maxDepth = 8;

  static dynamic generate(
    Map? schema,
    Map rootSpec, {
    Set<String>? visitedRefs,
    int depth = 0,
  }) {
    if (schema == null || depth > _maxDepth) return null;
    visitedRefs ??= <String>{};

    final ref = schema[r'$ref'];
    if (ref is String) {
      if (visitedRefs.contains(ref)) return null;
      final resolved = _resolveRef(ref, rootSpec);
      if (resolved == null) return null;
      return generate(
        resolved,
        rootSpec,
        visitedRefs: {...visitedRefs, ref},
        depth: depth + 1,
      );
    }

    if (schema.containsKey('example')) {
      return schema['example'];
    }
    final examples = schema['examples'];
    if (examples is List && examples.isNotEmpty) return examples.first;
    if (examples is Map && examples.isNotEmpty) {
      final first = examples.values.first;
      if (first is Map && first.containsKey('value')) return first['value'];
      return first;
    }
    if (schema.containsKey('default')) {
      return schema['default'];
    }

    final allOf = schema['allOf'];
    if (allOf is List && allOf.isNotEmpty) {
      final merged = <String, dynamic>{};
      for (final sub in allOf) {
        if (sub is! Map) continue;
        final value =
            generate(sub, rootSpec, visitedRefs: visitedRefs, depth: depth + 1);
        if (value is Map) merged.addAll(Map<String, dynamic>.from(value));
      }
      return merged;
    }
    final oneOf = schema['oneOf'];
    if (oneOf is List && oneOf.isNotEmpty && oneOf.first is Map) {
      return generate(oneOf.first as Map, rootSpec,
          visitedRefs: visitedRefs, depth: depth + 1);
    }
    final anyOf = schema['anyOf'];
    if (anyOf is List && anyOf.isNotEmpty && anyOf.first is Map) {
      return generate(anyOf.first as Map, rootSpec,
          visitedRefs: visitedRefs, depth: depth + 1);
    }

    final type = schema['type'] as String? ??
        (schema['properties'] is Map ? 'object' : 'string');

    switch (type) {
      case 'object':
        final properties = schema['properties'];
        final result = <String, dynamic>{};
        if (properties is Map) {
          properties.forEach((key, value) {
            if (value is Map) {
              result[key.toString()] = generate(value, rootSpec,
                  visitedRefs: visitedRefs, depth: depth + 1);
            }
          });
        }
        return result;
      case 'array':
        final items = schema['items'];
        if (items is Map) {
          return [
            generate(items, rootSpec, visitedRefs: visitedRefs, depth: depth + 1)
          ];
        }
        return [];
      case 'string':
        final enumValues = schema['enum'];
        if (enumValues is List && enumValues.isNotEmpty) {
          return enumValues.first;
        }
        switch (schema['format']) {
          case 'date-time':
            return DateTime.now().toIso8601String();
          case 'date':
            return DateTime.now().toIso8601String().split('T').first;
          case 'uuid':
            return '00000000-0000-0000-0000-000000000000';
          case 'email':
            return 'user@example.com';
          default:
            return 'string';
        }
      case 'integer':
      case 'number':
        final enumValues = schema['enum'];
        if (enumValues is List && enumValues.isNotEmpty) {
          return enumValues.first;
        }
        return 0;
      case 'boolean':
        return true;
      default:
        return null;
    }
  }

  static Map? _resolveRef(String ref, Map rootSpec) {
    if (!ref.startsWith('#/')) return null; // only local refs are supported
    dynamic current = rootSpec;
    for (final segment in ref.substring(2).split('/')) {
      if (current is Map && current.containsKey(segment)) {
        current = current[segment];
      } else {
        return null;
      }
    }
    return current is Map ? current : null;
  }
}
