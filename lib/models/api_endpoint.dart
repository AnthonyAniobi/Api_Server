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
  final String type;

  const ApiEndpoint(this.title, this.url, this.result, this.headers, this.type,
      this.requestBody);

  @override
  List<Object?> get props => throw [title, url, result, type];
}
