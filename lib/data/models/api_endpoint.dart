import 'package:equatable/equatable.dart';

class ApiEndpoint extends Equatable {
  final String title;
  final String url;
  final Map result;
  final Map headers;
  final Map requestBody;
  final Map errorResult;
  final String type;

  const ApiEndpoint({
    required this.title,
    required this.url,
    required this.result,
    required this.headers,
    required this.type,
    required this.requestBody,
    required this.errorResult,
  });

  ApiEndpoint copyWith({
    String? title,
    String? url,
    Map? result,
    Map? headers,
    Map? requestBody,
    Map? errorResult,
    String? type,
  }) {
    return ApiEndpoint(
      title: title ?? this.title,
      url: url ?? this.url,
      result: result ?? this.result,
      headers: headers ?? this.headers,
      requestBody: requestBody ?? this.requestBody,
      errorResult: errorResult ?? this.errorResult,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [url, type];
}
