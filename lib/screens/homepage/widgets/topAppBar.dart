import 'package:api_server/models/api_endpoint.dart';
import 'package:api_server/models/server/server.dart';
import 'package:api_server/screens/aboutpage/aboutpage.dart';
import 'package:api_server/screens/helppage/help_page.dart';
import 'package:api_server/screens/settingspage/settingspage.dart';
import 'package:api_server/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  final ValueNotifier<List<ApiEndpoint>> endpoints;
  final ValueNotifier<bool> isRunning;
  const TopAppBar(
      {super.key, required this.endpoints, required this.isRunning});

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
              'Local Api Server',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ValueListenableBuilder(
                    valueListenable: isRunning,
                    builder: (context, running, child) {
                      return Tooltip(
                        message: running ? 'stop' : 'run',
                        child: IconButton(
                            onPressed: () {
                              _startServer(context);
                            },
                            icon: Icon(
                              running ? Icons.stop : Icons.play_arrow,
                              color: Colors.black,
                            )),
                      );
                    }),
                PopupMenuButton(
                  tooltip: 'options',
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  onSelected: (value) {
                    _switchPages(context, value);
                  },
                  itemBuilder: ((context) => [
                        const PopupMenuItem(value: '1', child: Text('Help')),
                        const PopupMenuItem(value: '2', child: Text('About')),
                        const PopupMenuItem(
                            value: '3', child: Text('Settings')),
                      ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _startServer(BuildContext context) {
    // check if there is any endpoints
    if (endpoints.value.isEmpty && !isRunning.value) {
      Dialogs.alert(context,
          title: 'No Endpoint',
          message: 'You have to specify an endpoint before starting a server');
      return;
    }
    if (isRunning.value) {
      isRunning.value = false;
      Server().stop();
    } else {
      isRunning.value = true;
      Server().start(endpoints.value);
    }
    isRunning.notifyListeners();
  }

  void _switchPages(BuildContext context, String menuIndex) {
    switch (menuIndex) {
      case '1':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HelpPage()));
        break;
      case '2':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutPage()));
        break;
      case '3':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      default:
    }
  }
}
