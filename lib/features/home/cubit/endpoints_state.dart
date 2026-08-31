import 'package:equatable/equatable.dart';

import 'package:api_server/data/models/api_endpoint.dart';

class EndpointsState extends Equatable {
  final List<ApiEndpoint> endpoints;
  final int currentIndex;

  const EndpointsState({
    this.endpoints = const [],
    this.currentIndex = 0,
  });

  ApiEndpoint? get current =>
      currentIndex >= 0 && currentIndex < endpoints.length
          ? endpoints[currentIndex]
          : null;

  EndpointsState copyWith({
    List<ApiEndpoint>? endpoints,
    int? currentIndex,
  }) {
    return EndpointsState(
      endpoints: endpoints ?? this.endpoints,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [endpoints, currentIndex];
}

class ImportSummary {
  final int imported;
  final int skipped;

  const ImportSummary({required this.imported, required this.skipped});
}
