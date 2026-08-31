import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/core/widgets/dialogs.dart';
import 'package:api_server/data/models/api_endpoint.dart';
import 'package:api_server/features/home/cubit/endpoints_cubit.dart';
import 'package:api_server/features/home/cubit/endpoints_state.dart';
import 'package:api_server/features/home/view/widgets/dialogs/manual_endpoint_dialog.dart';
import 'package:api_server/features/home/view/widgets/endpoint_method_chip.dart';

class EndpointCard extends StatelessWidget {
  const EndpointCard({super.key, required this.listIndex});

  final int listIndex;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EndpointsCubit, EndpointsState, ({ApiEndpoint endpoint, bool isSelected})>(
      selector: (state) => (
        endpoint: state.endpoints[listIndex],
        isSelected: state.currentIndex == listIndex,
      ),
      builder: (context, data) {
        return Card(
          color: data.isSelected ? Theme.of(context).primaryColor : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () =>
                      context.read<EndpointsCubit>().selectEndpoint(listIndex),
                  splashColor: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.12),
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            Text(
                              data.endpoint.title,
                              style: TextStyle(
                                color:
                                    data.isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            EndpointMethodChip(type: data.endpoint.type),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data.endpoint.url,
                          style: TextStyle(
                            color: data.isSelected ? Colors.white : Colors.blue,
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
                      onPressed: () => showDialog(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<EndpointsCubit>(),
                          child: ManualEndpointDialog(editIndex: listIndex),
                        ),
                      ),
                    ),
                    EditOrDeleteButton(
                      text: 'Delete',
                      onPressed: () => _confirmDelete(context, data.endpoint),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, ApiEndpoint endpoint) async {
    final cubit = context.read<EndpointsCubit>();
    final confirmed = await Dialogs.warning(
      context,
      title: AppStrings.deleteEndpointDialogTitle,
      message: AppStrings.deleteEndpointDialogMessage(endpoint.title),
    );
    if (confirmed) {
      cubit.deleteEndpoint(listIndex);
    }
  }
}

class EditOrDeleteButton extends StatelessWidget {
  const EditOrDeleteButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
