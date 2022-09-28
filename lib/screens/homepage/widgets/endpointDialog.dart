import 'package:api_server/models/api_endpoint.dart';
import 'package:flutter/material.dart';

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
          height: 500,
          width: 400,
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
              _requestEndpoints(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text('Requires Authentication'),
                ],
              ),
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
                      onPressed: () {
                        if (edit) {
                          final Map previousResponse =
                              endpoints.value[editIndex!].result;
                          final Map previousHeader =
                              endpoints.value[editIndex!].headers;
                          final Map previousBody =
                              endpoints.value[editIndex!].requestBody;
                          endpoints.value[editIndex!] = ApiEndpoint(
                            _title.text,
                            _url.text,
                            previousResponse,
                            previousHeader,
                            _requestType.value,
                            previousBody,
                          );
                          endpoints.notifyListeners();
                          return Navigator.pop(context);
                        }
                        endpoints.value.add(
                          ApiEndpoint(_title.text, _url.text, {}, {},
                              _requestType.value, {}),
                        );
                        Navigator.pop(context);
                        endpoints.notifyListeners();
                        currentEndpoint.value = endpoints.value.length - 1;
                        currentEndpoint.notifyListeners();
                      },
                      child: const Text("Save")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                _requestButton(RequestType.update, _requestType),
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
