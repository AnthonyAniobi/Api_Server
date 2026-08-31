import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/data/models/api_endpoint.dart';
import 'package:api_server/features/home/cubit/endpoints_state.dart';

class EndpointsCubit extends Cubit<EndpointsState> {
  EndpointsCubit() : super(const EndpointsState());

  void addEndpoint(ApiEndpoint endpoint) {
    final updated = [...state.endpoints, endpoint];
    emit(state.copyWith(endpoints: updated, currentIndex: updated.length - 1));
  }

  /// Bulk-adds endpoints (used by schema import), skipping any that would
  /// collide on url+method with an existing endpoint.
  ImportSummary addEndpoints(List<ApiEndpoint> newEndpoints) {
    final updated = [...state.endpoints];
    var imported = 0;
    var skipped = 0;
    for (final endpoint in newEndpoints) {
      if (updated.any((e) => e.url == endpoint.url && e.type == endpoint.type)) {
        skipped++;
        continue;
      }
      updated.add(endpoint);
      imported++;
    }
    emit(state.copyWith(
      endpoints: updated,
      currentIndex: imported > 0 ? updated.length - 1 : state.currentIndex,
    ));
    return ImportSummary(imported: imported, skipped: skipped);
  }

  void updateEndpoint(int index, ApiEndpoint endpoint) {
    if (index < 0 || index >= state.endpoints.length) return;
    final updated = [...state.endpoints];
    updated[index] = endpoint;
    emit(state.copyWith(endpoints: updated));
  }

  void updateEndpointField(int index, EndpointField field, Map value) {
    if (index < 0 || index >= state.endpoints.length) return;
    final endpoint = state.endpoints[index];
    final ApiEndpoint updatedEndpoint;
    switch (field) {
      case EndpointField.response:
        updatedEndpoint = endpoint.copyWith(result: value);
        break;
      case EndpointField.requestBody:
        updatedEndpoint = endpoint.copyWith(requestBody: value);
        break;
      case EndpointField.headers:
        updatedEndpoint = endpoint.copyWith(headers: value);
        break;
      case EndpointField.errorResponse:
        updatedEndpoint = endpoint.copyWith(errorResult: value);
        break;
    }
    updateEndpoint(index, updatedEndpoint);
  }

  void deleteEndpoint(int index) {
    if (index < 0 || index >= state.endpoints.length) return;
    final updated = [...state.endpoints]..removeAt(index);
    final newIndex = updated.isEmpty
        ? 0
        : (state.currentIndex >= updated.length
            ? updated.length - 1
            : state.currentIndex);
    emit(state.copyWith(endpoints: updated, currentIndex: newIndex));
  }

  void selectEndpoint(int index) {
    if (index < 0 || index >= state.endpoints.length) return;
    emit(state.copyWith(currentIndex: index));
  }

  bool isDuplicate(String url, String type, {int? excludingIndex}) {
    for (var i = 0; i < state.endpoints.length; i++) {
      if (i == excludingIndex) continue;
      final endpoint = state.endpoints[i];
      if (endpoint.url == url && endpoint.type == type) return true;
    }
    return false;
  }
}
