import 'package:api_server/models/api_endpoint.dart';
import 'package:flutter/material.dart';

class EndpointsWidget extends StatelessWidget {
  final Function(int) onChange;
  final List<ApiEndpoint> endpoints;
  final int selectedEndpoint;
  const EndpointsWidget(
      {super.key,
      required this.onChange,
      required this.endpoints,
      required this.selectedEndpoint});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add Endpoints'),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return Dialog(
                            child: Wrap(
                              children: [
                                Text('Add an endpoint to the local host'),
                              ],
                            ),
                          );
                        }));
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: endpoints.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      color: index == selectedEndpoint
                          ? Theme.of(context).primaryColor
                          : null,
                      child: InkWell(
                        onTap: () {
                          onChange(index);
                        },
                        // Generally, material cards use onSurface with 12% opacity for the pressed state.
                        splashColor: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.12),
                        // Generally, material cards do not have a highlight overlay.
                        highlightColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                endpoints[index].title,
                                style: TextStyle(
                                  color: index == selectedEndpoint
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                endpoints[index].url,
                                style: TextStyle(
                                  color: index == selectedEndpoint
                                      ? Colors.white
                                      : Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })))
        ],
      ),
    );
  }
}
