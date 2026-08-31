import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_editor/json_editor.dart';

import 'package:api_server/data/models/api_endpoint.dart';
import 'package:api_server/features/home/cubit/endpoints_cubit.dart';
import 'package:api_server/features/home/cubit/endpoints_state.dart';

extension on EndpointField {
  String get label {
    switch (this) {
      case EndpointField.response:
        return 'Response';
      case EndpointField.requestBody:
        return 'Body';
      case EndpointField.headers:
        return 'Header';
      case EndpointField.errorResponse:
        return 'Error Response';
    }
  }

  String get tooltip {
    switch (this) {
      case EndpointField.response:
        return 'json response';
      case EndpointField.requestBody:
        return 'request body';
      case EndpointField.headers:
        return 'header response';
      case EndpointField.errorResponse:
        return 'error response';
    }
  }

  Map valueOf(ApiEndpoint endpoint) {
    switch (this) {
      case EndpointField.response:
        return endpoint.result;
      case EndpointField.requestBody:
        return endpoint.requestBody;
      case EndpointField.headers:
        return endpoint.headers;
      case EndpointField.errorResponse:
        return endpoint.errorResult;
    }
  }
}

/// Tabbed JSON editor for the currently-selected endpoint's response,
/// request body, headers, and error response payloads.
class JsonEditorPanel extends StatefulWidget {
  const JsonEditorPanel({super.key});

  @override
  State<JsonEditorPanel> createState() => _JsonEditorPanelState();
}

class _JsonEditorPanelState extends State<JsonEditorPanel> {
  EndpointField _activeField = EndpointField.response;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Column(
      children: [
        Container(
          color: Colors.white,
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: EndpointField.values
                .map((field) => _tabButton(field, backgroundColor))
                .toList(),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: BlocSelector<EndpointsCubit, EndpointsState, ApiEndpoint?>(
              selector: (state) => state.current,
              builder: (context, endpoint) {
                if (endpoint == null) return const SizedBox.shrink();
                return _JsonEditorTab(
                  key: ValueKey('${endpoint.url}-${endpoint.type}-${_activeField.name}'),
                  json: _activeField.valueOf(endpoint),
                  onValueChanged: (value) {
                    context.read<EndpointsCubit>().updateEndpointField(
                          context.read<EndpointsCubit>().state.currentIndex,
                          _activeField,
                          value,
                        );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabButton(EndpointField field, Color selectedColor) {
    final isActive = field == _activeField;
    return Tooltip(
      message: field.tooltip,
      child: InkWell(
        onTap: () => setState(() => _activeField = field),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? selectedColor : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          ),
          child: Text(
            field.label,
            style: TextStyle(color: isActive ? Colors.black : Colors.grey),
          ),
        ),
      ),
    );
  }
}

class _JsonEditorTab extends StatelessWidget {
  const _JsonEditorTab({super.key, required this.json, required this.onValueChanged});

  final Map json;
  final ValueChanged<Map> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return JsonEditor.string(
      jsonString: jsonEncode(json),
      onValueChanged: (value) {
        final decoded = jsonDecode(value.toString());
        if (decoded is Map) onValueChanged(decoded);
      },
    );
  }
}
