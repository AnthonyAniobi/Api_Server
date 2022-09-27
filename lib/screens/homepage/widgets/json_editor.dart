import 'dart:convert';

import 'package:api_server/models/api_endpoint.dart';
import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';

class JsonEditorWidget extends StatelessWidget {
  final ValueNotifier<List<ApiEndpoint>> endpointList;
  final ValueNotifier<int> currentEndpoint;
  const JsonEditorWidget(
      {super.key, required this.endpointList, required this.currentEndpoint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: ValueListenableBuilder(
          valueListenable: currentEndpoint,
          builder: (context, currentIndex, child) {
            return JsonEditor.string(
              // openDebug: true,
              jsonString: jsonEncode(endpointList.value[currentIndex].result),
              onValueChanged: (value) {
                endpointList.value[currentIndex].result.clear();
                endpointList.value[currentIndex].result
                    .addAll(jsonDecode(value.toString()));
              },
            );
          }),
    );
  }
}
