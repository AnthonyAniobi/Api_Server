import 'package:equatable/equatable.dart';

class ServerState extends Equatable {
  final bool isRunning;
  final int port;
  final String? url;
  final List<String> consoleMessages;

  const ServerState({
    this.isRunning = false,
    this.port = 8080,
    this.url,
    this.consoleMessages = const [],
  });

  ServerState copyWith({
    bool? isRunning,
    int? port,
    String? url,
    bool clearUrl = false,
    List<String>? consoleMessages,
  }) {
    return ServerState(
      isRunning: isRunning ?? this.isRunning,
      port: port ?? this.port,
      url: clearUrl ? null : (url ?? this.url),
      consoleMessages: consoleMessages ?? this.consoleMessages,
    );
  }

  @override
  List<Object?> get props => [isRunning, port, url, consoleMessages];
}
