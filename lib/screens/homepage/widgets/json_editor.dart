import 'dart:convert';

import 'package:api_server/models/api_endpoint.dart';
import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';

class _JsonTabs {
  static const String response = 'Response';
  static const String body = 'Body';
  static const String header = 'Header';
  static const String errorResponse = 'Error Response';
  // tool tips
  static const String responseTooltip = 'json response';
  static const String bodyTooltip = 'request body';
  static const String headerTooltip = 'header response';
  static const String errorTooltip = 'error response';
}

class JsonEditorWidget extends StatelessWidget {
  final ValueNotifier<List<ApiEndpoint>> endpointList;
  final ValueNotifier<int> currentEndpoint;
  JsonEditorWidget(
      {super.key, required this.endpointList, required this.currentEndpoint});

  //local variables
  final ValueNotifier<String> currentTab = ValueNotifier(_JsonTabs.response);
  Color tabBackgroundColor = Colors.white;
  Color selectedTabColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    selectedTabColor = Theme.of(context).scaffoldBackgroundColor;
    return ValueListenableBuilder(
        valueListenable: currentTab,
        builder: (context, tab, child) {
          return Column(
            children: [
              Container(
                color: tabBackgroundColor,
                child: Row(
                  children: [
                    _jsonTabButton(_JsonTabs.response, currentTab,
                        _JsonTabs.responseTooltip),
                    _jsonTabButton(
                        _JsonTabs.body, currentTab, _JsonTabs.bodyTooltip),
                    _jsonTabButton(
                        _JsonTabs.header, currentTab, _JsonTabs.headerTooltip),
                    _jsonTabButton(_JsonTabs.errorResponse, currentTab,
                        _JsonTabs.errorTooltip),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ValueListenableBuilder(
                      valueListenable: currentEndpoint,
                      builder: (context, currentIndex, child) {
                        return JsonEditorTab(
                          endpoint: endpointList.value[currentIndex],
                          jsonTab: tab,
                        );
                      }),
                ),
              ),
            ],
          );
        });
  }

  Widget _jsonTabButton(
      String value, ValueNotifier<String> currentTab, String tooltip) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () {
            currentTab.value = value;
            currentTab.notifyListeners();
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: value == currentTab.value
                    ? selectedTabColor
                    : tabBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(5)),
              ),
              child: Text(
                value,
                style: TextStyle(
                    color:
                        value == currentTab.value ? Colors.black : Colors.grey),
              )),
        ),
      ),
    );
  }
}

class JsonEditorTab extends StatelessWidget {
  JsonEditorTab({
    Key? key,
    required this.endpoint,
    required this.jsonTab,
  }) : super(key: key) {
    if (jsonTab == _JsonTabs.body) {
      _json = endpoint.requestBody;
    } else if (jsonTab == _JsonTabs.header) {
      _json = endpoint.headers;
    } else if (jsonTab == _JsonTabs.response) {
      _json = endpoint.result;
    } else if (jsonTab == _JsonTabs.errorResponse) {
      _json = endpoint.errorResult;
    } else {
      _json = {};
    }
  }

  final ApiEndpoint endpoint;
  final String jsonTab;
  // local variables
  Map _json = {};

  @override
  Widget build(BuildContext context) {
    return JsonEditor.string(
      jsonString: jsonEncode(_json),
      onValueChanged: (value) {
        if (jsonTab == _JsonTabs.body) {
          endpoint.requestBody.clear();
          endpoint.requestBody.addAll(jsonDecode(value.toString()));
        } else if (jsonTab == _JsonTabs.header) {
          endpoint.headers.clear();
          endpoint.headers.addAll(jsonDecode(value.toString()));
        } else if (jsonTab == _JsonTabs.errorResponse) {
          endpoint.errorResult.clear();
          endpoint.errorResult.addAll(jsonDecode(value.toString()));
        } else {
          endpoint.result.clear();
          endpoint.result.addAll(jsonDecode(value.toString()));
        }
      },
    );
  }
}
