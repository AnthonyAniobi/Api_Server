import 'package:api_server/models/api_endpoint.dart';
import 'package:api_server/screens/homepage/widgets/endpointDialog.dart';
import 'package:api_server/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class EndpointCard extends StatelessWidget {
  const EndpointCard({
    Key? key,
    required this.endpoints,
    required this.currentEndpoint,
    required this.listIndex,
  }) : super(key: key);

  final ValueNotifier<List<ApiEndpoint>> endpoints;
  final ValueNotifier<int> currentEndpoint;
  final int listIndex;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentEndpoint,
        builder: (context, currentIndex, child) {
          return Card(
            color: listIndex == currentIndex
                ? Theme.of(context).primaryColor
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      currentEndpoint.value = listIndex;
                      currentEndpoint.notifyListeners();
                    },
                    // Generally, material cards use onSurface with 12% opacity for the pressed state.
                    splashColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    // Generally, material cards do not have a highlight overlay.
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              Text(
                                endpoints.value[listIndex].title,
                                style: TextStyle(
                                  color: listIndex == currentIndex
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              _EndpointMethodChip(
                                  type: endpoints.value[listIndex].type),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            endpoints.value[listIndex].url,
                            style: TextStyle(
                              color: listIndex == currentIndex
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
                      EditOrDeleteButton(
                          text: 'Edit',
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) => EndpointDialog(
                                      endpoints: endpoints,
                                      currentEndpoint: currentEndpoint,
                                      edit: true,
                                      editIndex: listIndex,
                                    ));
                          }),
                      EditOrDeleteButton(
                          text: 'Delete',
                          onPressed: () async {
                            final bool _result = await Dialogs.warning(context,
                                title: 'Delete Endpoint',
                                message:
                                    'Are you sure you want to delete `${endpoints.value[listIndex].title}` endpoint');
                            if (_result) {
                              endpoints.value.removeAt(listIndex);
                              currentEndpoint.value = 0;
                              currentEndpoint.notifyListeners();
                              endpoints.notifyListeners();
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class _EndpointMethodChip extends StatelessWidget {
  final String type;
  Color color = Colors.black;

  _EndpointMethodChip({
    Key? key,
    required this.type,
  }) : super(key: key) {
    switch (type) {
      case RequestType.get:
        color = Colors.green;
        break;
      case RequestType.post:
        color = Colors.orangeAccent;
        break;
      case RequestType.delete:
        color = Colors.deepOrange;
        break;
      case RequestType.put:
        color = Colors.purple;
        break;
      case RequestType.patch:
        color = Colors.grey;
        break;
      default:
        color = Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type,
        style: TextStyle(fontSize: 10, color: Colors.white),
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
