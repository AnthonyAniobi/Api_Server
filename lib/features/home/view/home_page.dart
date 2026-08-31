import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/features/home/cubit/endpoints_cubit.dart';
import 'package:api_server/features/home/cubit/endpoints_state.dart';
import 'package:api_server/features/home/cubit/server_cubit.dart';
import 'package:api_server/features/home/cubit/server_state.dart';
import 'package:api_server/features/home/view/widgets/editor/json_editor_panel.dart';
import 'package:api_server/features/home/view/widgets/home_app_bar.dart';
import 'package:api_server/features/home/view/widgets/server_running_view.dart';
import 'package:api_server/features/home/view/widgets/sidebar/endpoints_sidebar.dart';
import 'package:api_server/features/home/view/widgets/terminal/resizable_terminal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Column(
        children: [
          Expanded(
            child: BlocSelector<ServerCubit, ServerState, bool>(
              selector: (state) => state.isRunning,
              builder: (context, isRunning) {
                return isRunning ? const ServerRunningView() : const _EndpointsView();
              },
            ),
          ),
          const ResizableTerminal(),
        ],
      ),
    );
  }
}

class _EndpointsView extends StatelessWidget {
  const _EndpointsView();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const EndpointsSidebar(),
        Expanded(
          flex: 4,
          child: BlocSelector<EndpointsCubit, EndpointsState, bool>(
            selector: (state) => state.endpoints.isEmpty,
            builder: (context, isEmpty) {
              return isEmpty
                  ? const Center(
                      child: Text(
                        AppStrings.noEndpointTitle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const JsonEditorPanel();
            },
          ),
        ),
      ],
    );
  }
}
