import 'package:api_server/models/server/server.dart';
import 'package:flutter/material.dart';

class BottomTerminal extends StatelessWidget {
  BottomTerminal({super.key});

  final double height = 200;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.grey.shade700,
      width: MediaQuery.of(context).size.width,
      child: ValueListenableBuilder(
          valueListenable: Server.consoleMessages,
          builder: (context, terminalList, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: terminalList.length,
                      itemBuilder: ((context, index) {
                        return Text.rich(TextSpan(
                            text: '>> ',
                            style: TextStyle(
                                color: Colors.pink[200],
                                fontWeight: FontWeight.w700),
                            children: [
                              TextSpan(
                                  text: terminalList[
                                      terminalList.length - index - 1],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300))
                            ]));
                      })),
                ),
                Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.clear_all,
                        color: Colors.white,
                      ),
                      onPressed: _clearConsole,
                    )),
              ],
            );
          }),
    );
  }

  void _clearConsole() {
    Server.consoleMessages.value.clear();
    Server.consoleMessages.notifyListeners();
  }
}
