import 'dart:convert';

import 'package:api_server/models/api_endpoint.dart';
import 'package:api_server/screens/homepage/widgets/endpointWidget.dart';
import 'package:api_server/screens/homepage/widgets/json_editor.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  ValueNotifier<List<ApiEndpoint>> endpoints =
      ValueNotifier<List<ApiEndpoint>>([]);
  ValueNotifier<int> currentEndpoint = ValueNotifier<int>(0);

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
              icon: const Icon(
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
                  currentEndpoint: currentEndpoint,
                  endpoints: endpoints,
                ),
                Expanded(
                    flex: 4,
                    child: ValueListenableBuilder(
                        valueListenable: endpoints,
                        builder: (context, endpointValues, child) {
                          return endpointValues.isEmpty
                              ? const Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      'No Endpoint created!\nClick Add Endpoints to create an endpoint'),
                                )
                              : JsonEditorWidget(
                                  currentEndpoint: currentEndpoint,
                                  endpointList: endpoints,
                                );
                        })),
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
