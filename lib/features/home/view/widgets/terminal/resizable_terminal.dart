import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/features/home/cubit/server_cubit.dart';
import 'package:api_server/features/home/cubit/server_state.dart';

/// The bottom console/terminal panel. Its top edge can be dragged to make
/// the panel taller or shorter.
class ResizableTerminal extends StatefulWidget {
  const ResizableTerminal({super.key});

  static const double minHeight = 80;
  static const double defaultHeight = 200;

  @override
  State<ResizableTerminal> createState() => _ResizableTerminalState();
}

class _ResizableTerminalState extends State<ResizableTerminal> {
  double _height = ResizableTerminal.defaultHeight;

  double _maxHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.6;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DragHandle(
          onDrag: (deltaY) {
            setState(() {
              _height = (_height - deltaY)
                  .clamp(ResizableTerminal.minHeight, _maxHeight(context));
            });
          },
        ),
        SizedBox(
          height: _height,
          width: double.infinity,
          child: const _TerminalBody(),
        ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.onDrag});

  final ValueChanged<double> onDrag;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeUpDown,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: (details) => onDrag(details.delta.dy),
        child: Container(
          height: 8,
          width: double.infinity,
          color: Colors.grey.shade800,
          alignment: Alignment.center,
          child: Container(
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}

class _TerminalBody extends StatefulWidget {
  const _TerminalBody();

  @override
  State<_TerminalBody> createState() => _TerminalBodyState();
}

class _TerminalBodyState extends State<_TerminalBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade700,
      child: BlocSelector<ServerCubit, ServerState, List<String>>(
        selector: (state) => state.consoleMessages,
        builder: (context, terminalList) {
          _scrollToBottom();
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: terminalList.length,
                  itemBuilder: (context, index) {
                    return Text.rich(TextSpan(
                      text: '>> ',
                      style: TextStyle(
                        color: Colors.pink[200],
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: terminalList[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ));
                  },
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Tooltip(
                  message: AppStrings.clearConsole,
                  child: IconButton(
                    icon: const Icon(Icons.clear_all, color: Colors.white),
                    onPressed: () => context.read<ServerCubit>().clearConsole(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
