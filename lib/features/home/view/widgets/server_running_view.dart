import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/features/home/cubit/server_cubit.dart';
import 'package:api_server/features/home/cubit/server_state.dart';

/// Shown while the local server is running: a loader, the reachable server
/// url (copyable), and a stop button.
class ServerRunningView extends StatelessWidget {
  const ServerRunningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppStrings.serverRunning,
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 10),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const _ServerUrl(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ServerCubit>().stop(),
            child: const Text(AppStrings.stopServer),
          ),
        ],
      ),
    );
  }
}

class _ServerUrl extends StatelessWidget {
  const _ServerUrl();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ServerCubit, ServerState, String?>(
      selector: (state) => state.url,
      builder: (context, url) {
        if (url == null) return const SizedBox.shrink();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
              url,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 6),
            Tooltip(
              message: AppStrings.copyUrl,
              child: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => _copyUrl(context, url),
              ),
            ),
          ],
        );
      },
    );
  }

  void _copyUrl(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.urlCopied),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
