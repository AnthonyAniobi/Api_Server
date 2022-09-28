import 'dart:convert';

import 'package:api_server/models/api_endpoint.dart';
import 'package:api_server/screens/homepage/widgets/bottom_terminal.dart';
import 'package:api_server/screens/homepage/widgets/endpointWidget.dart';
import 'package:api_server/screens/homepage/widgets/json_editor.dart';
import 'package:api_server/screens/homepage/widgets/topAppBar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  ValueNotifier<List<ApiEndpoint>> endpoints =
      ValueNotifier<List<ApiEndpoint>>([]);
  ValueNotifier<int> currentEndpoint = ValueNotifier<int>(0);
  ValueNotifier<List<String>> consoleMessages =
      ValueNotifier<List<String>>(List.generate(20, (index) => 1.toString()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopAppBar(endpoints: endpoints),
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
          BottomTerminal(consoleMessage: consoleMessages),
        ],
      ),
    );
  }
}
