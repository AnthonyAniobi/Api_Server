import 'dart:convert';

import 'package:api_server/models/api_endpoint.dart';
import 'package:api_server/models/server/server.dart';
import 'package:api_server/screens/homepage/widgets/bottom_terminal.dart';
import 'package:api_server/screens/homepage/widgets/endpointWidget.dart';
import 'package:api_server/screens/homepage/widgets/json_editor.dart';
import 'package:api_server/screens/homepage/widgets/topAppBar.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final ValueNotifier<List<ApiEndpoint>> endpoints =
      ValueNotifier<List<ApiEndpoint>>([]);
  final ValueNotifier<int> currentEndpoint = ValueNotifier<int>(0);
  final ValueNotifier<bool> isRunning = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopAppBar(
            endpoints: endpoints,
            isRunning: isRunning,
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: isRunning,
                builder: (context, running, child) {
                  return running
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Running  !!!',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 10),
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text('Click the Stop button above to Stop Server')
                            ],
                          ))
                      : Row(
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
                        );
                }),
          ),
          BottomTerminal(),
        ],
      ),
    );
  }
}
