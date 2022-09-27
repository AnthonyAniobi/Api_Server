enum RequestType {
  Get,
  Post,
  Update,
  Delete,
}

class ApiEndpoint {
  final String title;
  final String url;
  final Map result;
  final Map headers;
  final RequestType type;

  ApiEndpoint(this.title, this.url, this.result, this.headers, this.type);

  static List<ApiEndpoint> all = [
    ApiEndpoint('title', 'url', {}, {}, RequestType.Get),
    ApiEndpoint(
        'title1', 'url1', {'url': 22}, {'token': '23'}, RequestType.Post),
  ];
}
