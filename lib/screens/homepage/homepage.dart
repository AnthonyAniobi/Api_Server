import 'package:api_server/screens/homepage/widgets/endpoints.dart';
import 'package:api_server/screens/homepage/widgets/json_editor.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Api Server',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.play_arrow,
                color: Colors.black,
              ))
        ],
      ),
      body: Row(
        children: [
          Expanded(flex: 2, child: EndpointsWidget()),
          Expanded(flex: 4, child: JsonEditorWidget()),
          // Expanded(flex: 1, child: Container(color: Colors.white)),
        ],
      ),
    );
  }
}
