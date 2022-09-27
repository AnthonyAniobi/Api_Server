class ApiEndpoint {
  final String title;
  final String url;
  final Map result;
  final Map headers;

  ApiEndpoint(this.title, this.url, this.result, this.headers);

  static List<ApiEndpoint> all = [
    ApiEndpoint('title', 'url', {}, {}),
    ApiEndpoint('title1', 'url1', {'url': 22}, {'token': '23'}),
  ];
}
