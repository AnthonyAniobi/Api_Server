import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';

class JsonEditorWidget extends StatelessWidget {
  const JsonEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: JsonEditor.string(
        // openDebug: true,
        jsonString: '''
                      {
                        // This is a comment
                        "name": "young chan",
                        "number": 100,
                        "boo": true,
                        "user": {"age": 20, "tall": 1.8},
                        "cities": ["beijing", "shanghai", "shenzhen"]
                      }''',
        onValueChanged: (value) {
          // _elementResult = value;
          print(value);
        },
      ),
    );
  }
}
