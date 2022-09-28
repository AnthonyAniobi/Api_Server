import 'dart:io';

import 'package:api_server/models/api_endpoint.dart';
import 'package:api_server/models/server/request_parser.dart';
import 'package:flutter/material.dart';

class Server {
  HttpServer? server;

  // singleton setup
  static final Server _server = Server._internal();
  factory Server() => _server;
  Server._internal();

  // initialize list of console elements
  static ValueNotifier<List<String>> consoleMessages =
      ValueNotifier<List<String>>([]);

  Future start(List<ApiEndpoint> endpoints, {int port = 80}) async {
    server = await HttpServer.bind(InternetAddress.anyIPv6, port);
    writeToConsole('server started....');
    await server!.forEach((HttpRequest request) {
      RequestParser(endpoints: endpoints).parse(request);
      // write request details to console
      writeToConsole("${request.method} at ${request.uri.path}");
      request.response.close();
    });
  }

  Future stop() async {
    await server?.close(force: true);

    writeToConsole('server stopped!');
  }

  static writeToConsole(String text) {
    consoleMessages.value.add(text);
    consoleMessages.notifyListeners();
  }
}
