import 'package:api_server/models/api_endpoint.dart';
import 'package:api_server/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class EndpointCard extends StatelessWidget {
  const EndpointCard({
    Key? key,
    required this.selectedEndpoint,
    required this.onChange,
    required this.endpoints,
    required this.listIndex,
  }) : super(key: key);

  final int selectedEndpoint;
  final Function(int p1) onChange;
  final List<ApiEndpoint> endpoints;
  final int listIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          listIndex == selectedEndpoint ? Theme.of(context).primaryColor : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                onChange(listIndex);
              },
              // Generally, material cards use onSurface with 12% opacity for the pressed state.
              splashColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              // Generally, material cards do not have a highlight overlay.
              highlightColor: Colors.transparent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      endpoints[listIndex].title,
                      style: TextStyle(
                        color: listIndex == selectedEndpoint
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      endpoints[listIndex].url,
                      style: TextStyle(
                        color: listIndex == selectedEndpoint
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
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: Column(
              children: [
                EditOrDeleteButton(text: 'Edit', onPressed: () async {}),
                EditOrDeleteButton(
                    text: 'Delete',
                    onPressed: () async {
                      final bool _result = await Dialogs.warning(context,
                          title: 'Delete Endpoint',
                          message: 'Are you sure you want to delete endpoint');
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EditOrDeleteButton extends StatelessWidget {
  const EditOrDeleteButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
