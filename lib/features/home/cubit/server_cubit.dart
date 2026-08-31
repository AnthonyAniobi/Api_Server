import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/utils/network_utils.dart';
import 'package:api_server/data/models/api_endpoint.dart';
import 'package:api_server/data/server/local_server.dart';
import 'package:api_server/features/home/cubit/server_state.dart';

class ServerCubit extends Cubit<ServerState> {
  final LocalServer _server;

  ServerCubit({LocalServer? server})
      : _server = server ?? LocalServer.instance,
        super(const ServerState());

  Future<void> start(List<ApiEndpoint> Function() getEndpoints) async {
    final ip = await NetworkUtils.getLocalIpAddress();
    emit(state.copyWith(isRunning: true, url: 'http://$ip:${state.port}'));
    try {
      await _server.start(getEndpoints: getEndpoints, port: state.port, onLog: _log);
    } catch (e) {
      _log('failed to start server: $e');
      emit(state.copyWith(isRunning: false, clearUrl: true));
    }
  }

  Future<void> stop() async {
    await _server.stop(onLog: _log);
    emit(state.copyWith(isRunning: false, clearUrl: true));
  }

  void setPort(int port) {
    if (state.isRunning || port <= 0) return;
    emit(state.copyWith(port: port));
  }

  void clearConsole() {
    emit(state.copyWith(consoleMessages: []));
  }

  void _log(String message) {
    emit(state.copyWith(consoleMessages: [...state.consoleMessages, message]));
  }
}
