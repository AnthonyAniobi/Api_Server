import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/core/widgets/dialogs.dart';
import 'package:api_server/features/about/about_page.dart';
import 'package:api_server/features/help/help_page.dart';
import 'package:api_server/features/home/cubit/endpoints_cubit.dart';
import 'package:api_server/features/home/cubit/server_cubit.dart';
import 'package:api_server/features/home/cubit/server_state.dart';
import 'package:api_server/features/settings/settings_page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: preferredSize.height,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 3,
          color: Colors.grey.shade400,
        )
      ]),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.appTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                _PortField(),
                SizedBox(width: 10),
                _RunButton(),
                _OptionsMenu(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _PortField extends StatefulWidget {
  const _PortField();

  @override
  State<_PortField> createState() => _PortFieldState();
}

class _PortFieldState extends State<_PortField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: context.read<ServerCubit>().state.port.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerCubit, ServerState>(
      buildWhen: (previous, current) => previous.isRunning != current.isRunning,
      builder: (context, state) {
        return SizedBox(
          width: 90,
          child: TextField(
            controller: _controller,
            enabled: !state.isRunning,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: const InputDecoration(
              isDense: true,
              labelText: AppStrings.portLabel,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final port = int.tryParse(value);
              if (port != null) {
                context.read<ServerCubit>().setPort(port);
              }
            },
          ),
        );
      },
    );
  }
}

class _RunButton extends StatelessWidget {
  const _RunButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerCubit, ServerState>(
      builder: (context, serverState) {
        return Tooltip(
          message: serverState.isRunning
              ? AppStrings.stopTooltip
              : AppStrings.runTooltip,
          child: IconButton(
            onPressed: () => _toggleServer(context, serverState),
            icon: Icon(
              serverState.isRunning ? Icons.stop : Icons.play_arrow,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  void _toggleServer(BuildContext context, ServerState serverState) {
    final endpointsState = context.read<EndpointsCubit>().state;
    if (endpointsState.endpoints.isEmpty && !serverState.isRunning) {
      Dialogs.alert(
        context,
        title: AppStrings.noEndpointDialogTitle,
        message: AppStrings.noEndpointDialogMessage,
      );
      return;
    }
    final serverCubit = context.read<ServerCubit>();
    if (serverState.isRunning) {
      serverCubit.stop();
    } else {
      final endpointsCubit = context.read<EndpointsCubit>();
      serverCubit.start(() => endpointsCubit.state.endpoints);
    }
  }
}

class _OptionsMenu extends StatelessWidget {
  const _OptionsMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: AppStrings.optionsTooltip,
      icon: const Icon(Icons.arrow_drop_down_sharp),
      onSelected: (value) => _switchPages(context, value),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'help', child: Text('Help')),
        PopupMenuItem(value: 'about', child: Text('About')),
        PopupMenuItem(value: 'settings', child: Text('Settings')),
      ],
    );
  }

  void _switchPages(BuildContext context, String menuItem) {
    final Widget page;
    switch (menuItem) {
      case 'help':
        page = const HelpPage();
        break;
      case 'about':
        page = const AboutPage();
        break;
      case 'settings':
        page = const SettingsPage();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
