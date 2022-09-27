import 'dart:convert';

import 'package:api_server/models/api_endpoint.dart';
import 'package:api_server/screens/homepage/widgets/endpointWidget.dart';
import 'package:api_server/screens/homepage/widgets/json_editor.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<ApiEndpoint> endpoints = ApiEndpoint.all;
  int currentEndpoint = 0;

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
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                EndpointsWidget(
                  selectedEndpoint: currentEndpoint,
                  onChange: (index) {
                    setState(() {
                      currentEndpoint = index;
                    });
                  },
                  endpoints: endpoints,
                ),
                Expanded(
                    flex: 4,
                    child: JsonEditorWidget(
                      json: endpoints[currentEndpoint].result,
                      onChanged: (value) {
                        endpoints[currentEndpoint].result.clear();
                        endpoints[currentEndpoint]
                            .result
                            .addAll(jsonDecode(value.toString()));
                      },
                    )),
                // Expanded(flex: 1, child: Container(color: Colors.white)),
              ],
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
