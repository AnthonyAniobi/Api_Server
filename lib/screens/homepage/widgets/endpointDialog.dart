import 'package:api_server/models/api_endpoint.dart';
import 'package:flutter/material.dart';

class EndpointDialog extends StatefulWidget {
  final ValueNotifier<List<ApiEndpoint>> endpoints;
  final ValueNotifier<int> currentEndpoint;
  final bool edit;
  const EndpointDialog(
      {super.key,
      required this.endpoints,
      required this.currentEndpoint,
      this.edit = false});

  @override
  State<EndpointDialog> createState() => _EndpointDialogState();
}

class _EndpointDialogState extends State<EndpointDialog> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _url = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.edit) {
      _title.text = widget.endpoints.value[widget.currentEndpoint.value].title;
      _url.text = widget.endpoints.value[widget.currentEndpoint.value].url;
      // add other fields here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 200,
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
                        if (widget.edit) {
                          widget.endpoints.value[widget.currentEndpoint.value] =
                              ApiEndpoint(_title.text, _url.text, {}, {},
                                  RequestType.Get);
                          widget.endpoints.notifyListeners();
                          return Navigator.pop(context);
                        }
                        print('added endpoint');
                        widget.endpoints.value.add(
                          ApiEndpoint(
                              _title.text, _url.text, {}, {}, RequestType.Get),
                        );
                        Navigator.pop(context);
                        widget.endpoints.notifyListeners();
                        widget.currentEndpoint.value =
                            widget.endpoints.value.length - 1;
                        widget.currentEndpoint.notifyListeners();
                      },
                      child: const Text("Save")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
