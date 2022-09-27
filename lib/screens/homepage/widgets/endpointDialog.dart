import 'package:api_server/models/api_endpoint.dart';
import 'package:flutter/material.dart';

class EndpointDialog extends StatefulWidget {
  final List<ApiEndpoint> endpoints;
  const EndpointDialog({super.key, required this.endpoints});

  @override
  State<EndpointDialog> createState() => _EndpointDialogState();
}

class _EndpointDialogState extends State<EndpointDialog> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _url = TextEditingController();

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
                        widget.endpoints.add(
                          ApiEndpoint(
                              _title.text, _url.text, {}, {}, RequestType.Get),
                        );
                        Navigator.pop(context);
                        // onChange(widget.endpoints.length - 1);
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
