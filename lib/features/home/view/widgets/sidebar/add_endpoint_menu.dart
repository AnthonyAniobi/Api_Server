import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/features/home/cubit/endpoints_cubit.dart';
import 'package:api_server/features/home/view/widgets/dialogs/import_schema_dialog.dart';
import 'package:api_server/features/home/view/widgets/dialogs/manual_endpoint_dialog.dart';

/// The sidebar "Add" button: lets the user choose between filling in an
/// endpoint by hand or generating endpoints from an imported OpenAPI spec.
class AddEndpointMenu extends StatelessWidget {
  const AddEndpointMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Add endpoint',
      icon: const Icon(Icons.add),
      onPressed: () => _showChooser(context),
    );
  }

  Future<void> _showChooser(BuildContext context) async {
    final cubit = context.read<EndpointsCubit>();
    final choice = await showDialog<_AddChoice>(
      context: context,
      builder: (context) => const _AddChoiceDialog(),
    );

    if (choice == null || !context.mounted) return;

    switch (choice) {
      case _AddChoice.manual:
        showDialog(
          context: context,
          builder: (dialogContext) => BlocProvider.value(
            value: cubit,
            child: const ManualEndpointDialog(),
          ),
        );
        break;
      case _AddChoice.import:
        showDialog(
          context: context,
          builder: (dialogContext) => BlocProvider.value(
            value: cubit,
            child: const ImportSchemaDialog(),
          ),
        );
        break;
    }
  }
}

enum _AddChoice { manual, import }

class _AddChoiceDialog extends StatelessWidget {
  const _AddChoiceDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add an endpoint', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            _ChoiceTile(
              icon: Icons.edit_note,
              title: AppStrings.addManually,
              description: AppStrings.addManuallyDescription,
              onTap: () => Navigator.pop(context, _AddChoice.manual),
            ),
            const SizedBox(height: 10),
            _ChoiceTile(
              icon: Icons.file_upload_outlined,
              title: AppStrings.importSchema,
              description: AppStrings.importSchemaDescription,
              onTap: () => Navigator.pop(context, _AddChoice.import),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(description,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
