class RequestType {
  static const String get = "GET";
  static const String post = "POST";
  static const String update = "UPDATE";
  static const String delete = "Delete";
}

class ApiEndpoint {
  final String title;
  final String url;
  final Map result;
  final Map headers;
  final Map requestBody;
  final String type;

  ApiEndpoint(this.title, this.url, this.result, this.headers, this.type,
      this.requestBody);
}
