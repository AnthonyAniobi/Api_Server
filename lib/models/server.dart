import 'dart:io';

class Server {
  HttpServer? server;

  // singleton setup
  static final Server _server = Server._internal();
  factory Server() => _server;
  Server._internal();

  Future start() async {
    server = await HttpServer.bind(InternetAddress.anyIPv6, 80);
    print('server started....');
    await server!.forEach((HttpRequest request) {
      request.response.write('Hello, world!');
      request.response.close();
    });
  }

  Future stop() async {
    await server!.close(force: true);
    print('server stopped!');
  }
}
