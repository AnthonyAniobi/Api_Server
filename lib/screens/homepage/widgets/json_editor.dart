import 'dart:convert';

import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';

class JsonEditorWidget extends StatelessWidget {
  final Map json;
  final Function(JsonElement) onChanged;
  const JsonEditorWidget(
      {super.key, required this.json, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {}, child: const Text("Set endpoint")),
            ],
          ),
          Expanded(
            child: JsonEditor.string(
              // openDebug: true,
              jsonString: jsonEncode(json),
              onValueChanged: (value) {
                onChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
