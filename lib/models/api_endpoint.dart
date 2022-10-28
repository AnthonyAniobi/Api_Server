import 'package:equatable/equatable.dart';

class RequestType {
  static const String get = "GET";
  static const String post = "POST";
  static const String put = "PUT";
  static const String patch = "PATCH";
  static const String delete = "DELETE";
}

class ApiEndpoint extends Equatable {
  final String title;
  final String url;
  final Map result;
  final Map headers;
  final Map requestBody;
  final Map errorResult;
  final String type;

  const ApiEndpoint(
      {required this.title,
      required this.url,
      required this.result,
      required this.headers,
      required this.type,
      required this.requestBody,
      required this.errorResult});

  @override
  List<Object?> get props => [url, type];
}
