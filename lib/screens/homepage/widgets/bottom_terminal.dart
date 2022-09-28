import 'package:flutter/material.dart';

class BottomTerminal extends StatelessWidget {
  BottomTerminal({super.key, required this.consoleMessage});

  final ValueNotifier<List<String>> consoleMessage;

  final double height = 200;
  final ScrollController listController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: ValueListenableBuilder(
          valueListenable: consoleMessage,
          builder: (context, terminalList, child) {
            return Stack(
              children: [
                Container(
                  height: height,
                  padding: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                  ),
                  child: ListView.builder(
                      reverse: true,
                      controller: listController,
                      itemCount: terminalList.length,
                      itemBuilder: ((context, index) {
                        return Text.rich(TextSpan(
                            text: '>> ',
                            style: TextStyle(
                                color: Colors.pink[200],
                                fontWeight: FontWeight.w700),
                            children: [
                              TextSpan(
                                  text:
                                      'some values ${terminalList.length - index}',
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
    consoleMessage.value.clear();
    consoleMessage.notifyListeners();
  }
}
