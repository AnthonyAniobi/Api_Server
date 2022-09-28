import 'dart:convert';
import 'dart:io';

import 'package:api_server/models/api_endpoint.dart';

class RequestParser {
  final List<ApiEndpoint> endpoints;

  // local variables
  final Map _notFound = {'status': 'error', 'message': 'endpoint not found'};

  RequestParser({required this.endpoints});

  void parse(HttpRequest request) {
    endpoints.sort(((a, b) => a.url.compareTo(b.url)));

    for (ApiEndpoint ePoint in endpoints) {
      // check if path exists
      if (ePoint.url == request.uri.path) {
        // check if request type is same as in path
        if (ePoint.type == request.method) {
          // check if body
          request.response.write(jsonEncode(ePoint.result));
          return;
        }
      }
    }
    request.response.write(jsonEncode(_notFound));
  }
}
