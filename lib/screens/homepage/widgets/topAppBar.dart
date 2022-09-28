import 'package:api_server/models/api_endpoint.dart';
import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  final ValueNotifier<List<ApiEndpoint>> endpoints;
  const TopAppBar({super.key, required this.endpoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 3,
          color: Colors.grey.shade400,
        )
      ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Api Server',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Tooltip(
                  message: 'run',
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                      )),
                ),
                PopupMenuButton(
                  tooltip: 'options',
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  onSelected: (value) {},
                  itemBuilder: ((context) => [
                        PopupMenuItem(value: '1', child: Text('Howdy')),
                        PopupMenuItem(value: '2', child: Text('Howdy')),
                        PopupMenuItem(value: '3', child: Text('Howdy')),
                      ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
