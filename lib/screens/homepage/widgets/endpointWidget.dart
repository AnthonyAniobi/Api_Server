import 'package:api_server/models/api_endpoint.dart';
import 'package:api_server/screens/homepage/widgets/endpointCard.dart';
import 'package:api_server/screens/homepage/widgets/endpointDialog.dart';
import 'package:flutter/material.dart';

class EndpointsWidget extends StatelessWidget {
  final Function(int) onChange;
  final List<ApiEndpoint> endpoints;
  final int selectedEndpoint;

  EndpointsWidget(
      {super.key,
      required this.onChange,
      required this.endpoints,
      required this.selectedEndpoint});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
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
                          return EndpointDialog(endpoints: endpoints);
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
                    return EndpointCard(
                        selectedEndpoint: selectedEndpoint,
                        onChange: onChange,
                        endpoints: endpoints,
                        listIndex: index);
                  })))
        ],
      ),
    );
  }
}
