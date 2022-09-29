import 'package:api_server/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:api_server/models/api_endpoint.dart';

class EndpointDialog extends StatelessWidget {
  final ValueNotifier<List<ApiEndpoint>> endpoints;
  final ValueNotifier<int> currentEndpoint;
  final bool edit;
  final int? editIndex;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _url = TextEditingController();
  ValueNotifier<String> _requestType = ValueNotifier<String>(RequestType.get);

  EndpointDialog({
    super.key,
    required this.endpoints,
    required this.currentEndpoint,
    this.edit = false,
    this.editIndex,
  }) {
    if (edit) {
      _title.text = endpoints.value[editIndex!].title;
      _url.text = endpoints.value[editIndex!].url;
      _requestType.value = endpoints.value[editIndex!].type;
      // add other fields here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 280,
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add an endpoint to the local host',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              TextField(
                controller: _title,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              TextField(
                controller: _url,
                decoration: const InputDecoration(
                  label: Text("Url"),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Request Method'),
              const SizedBox(height: 5),
              _requestEndpoints(),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () async {
                        if (!_verifyEntry(context)) {
                          return;
                        }

                        if (edit) {
                          final Map previousResponse =
                              endpoints.value[editIndex!].result;
                          final Map previousHeader =
                              endpoints.value[editIndex!].headers;
                          final Map previousBody =
                              endpoints.value[editIndex!].requestBody;
                          final Map previousError =
                              endpoints.value[editIndex!].errorResult;
                          endpoints.value[editIndex!] = ApiEndpoint(
                            title: _title.text,
                            url: _url.text,
                            result: previousResponse,
                            headers: previousHeader,
                            requestBody: previousBody,
                            errorResult: previousError,
                            type: _requestType.value,
                          );
                          endpoints.notifyListeners();
                          return Navigator.pop(context);
                        }
                        endpoints.value.add(
                          ApiEndpoint(
                            title: _title.text,
                            url: _url.text,
                            type: _requestType.value,
                            result: {},
                            errorResult: {},
                            requestBody: {},
                            headers: {},
                          ),
                        );
                        Navigator.pop(context);
                        currentEndpoint.value = endpoints.value.length - 1;
                        currentEndpoint.notifyListeners();
                        endpoints.notifyListeners();
                      },
                      child: const Text("Save")),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  bool _verifyEntry(BuildContext context) {
    bool result = true;
    if (_title.text.isEmpty) {
      result = false;
      Dialogs.alert(context,
          title: 'Empty Title', message: "Title should not be empty");
    } else if (_url.text.isEmpty) {
      if (endpoints.value.isEmpty) {
        result = true;
        _url.text = '/';
      } else {
        result = false;
        Dialogs.alert(context,
            title: 'Empty Endpoint',
            message: "The endpoint url should not be empty");
      }
    } else {
      for (ApiEndpoint ePoint in endpoints.value) {
        if (ePoint.url == _url.text && ePoint.type == _requestType.value) {
          result = false;
          Dialogs.alert(context,
              title: 'Endpoint exists',
              message:
                  "This endpoint has already been created please use another url");
        }
      }
    }
    final addedUrl = _url.text;
    if (!addedUrl.startsWith('/')) {
      _url.text = '/$addedUrl';
    }
    return result;
  }

  Widget _requestEndpoints() {
    return ValueListenableBuilder(
        valueListenable: _requestType,
        builder: ((context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _requestButton(RequestType.get, _requestType),
                _requestButton(RequestType.post, _requestType),
                _requestButton(RequestType.delete, _requestType),
                _requestButton(RequestType.put, _requestType),
                _requestButton(RequestType.patch, _requestType),
              ],
            )));
  }

  Widget _requestButton(String value, ValueNotifier<String> currentVal) {
    return InkWell(
      onTap: () {
        currentVal.value = value;
        currentVal.notifyListeners();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: value == currentVal.value
                  ? Colors.blue
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                    color: Colors.black.withOpacity(0.25))
              ]),
          child: Text(
            value,
            style: TextStyle(
                color: value == currentVal.value ? Colors.white : Colors.black),
          )),
    );
  }
}
