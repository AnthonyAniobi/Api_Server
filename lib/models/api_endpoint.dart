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
  final String type;

  ApiEndpoint(this.title, this.url, this.result, this.headers, this.type);

  static List<ApiEndpoint> all = [
    ApiEndpoint('title', 'url', {}, {}, RequestType.get),
    ApiEndpoint(
        'title1', 'url1', {'url': 22}, {'token': '23'}, RequestType.post),
  ];
}
