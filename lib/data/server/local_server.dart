import 'dart:io';

import 'package:api_server/data/models/api_endpoint.dart';
import 'package:api_server/data/server/request_parser.dart';

typedef ServerLogger = void Function(String message);

class LocalServer {
  HttpServer? _server;

  // singleton setup
  static final LocalServer instance = LocalServer._internal();
  factory LocalServer() => instance;
  LocalServer._internal();

  bool get isRunning => _server != null;

  Future<void> start({
    required List<ApiEndpoint> Function() getEndpoints,
    required int port,
    required ServerLogger onLog,
  }) async {
    _server = await HttpServer.bind(InternetAddress.anyIPv6, port);
    onLog('server started....');
    _server!.forEach((HttpRequest request) {
      RequestParser(endpoints: getEndpoints()).parse(request);
      onLog('${request.method} at ${request.uri.path}');
      request.response.close();
    });
  }

  Future<void> stop({required ServerLogger onLog}) async {
    await _server?.close(force: true);
    _server = null;
    onLog('server stopped!');
  }
}
