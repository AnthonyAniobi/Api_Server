import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/core/constants/request_type.dart';
import 'package:api_server/core/widgets/dialogs.dart';
import 'package:api_server/data/models/api_endpoint.dart';
import 'package:api_server/features/home/cubit/endpoints_cubit.dart';

/// Manual endpoint creation/edit form. Reads and writes through
/// [EndpointsCubit] rather than mutating state directly.
class ManualEndpointDialog extends StatefulWidget {
  const ManualEndpointDialog({super.key, this.editIndex});

  final int? editIndex;

  bool get isEditing => editIndex != null;

  @override
  State<ManualEndpointDialog> createState() => _ManualEndpointDialogState();
}

class _ManualEndpointDialogState extends State<ManualEndpointDialog> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _url = TextEditingController();
  String _requestType = RequestType.get;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      final endpoint =
          context.read<EndpointsCubit>().state.endpoints[widget.editIndex!];
      _title.text = endpoint.title;
      _url.text = endpoint.url;
      _requestType = endpoint.type;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add an endpoint to the local host',
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: _title,
                decoration: const InputDecoration(label: Text('Title')),
              ),
              TextField(
                controller: _url,
                decoration: const InputDecoration(label: Text('Url')),
              ),
              const SizedBox(height: 20),
              const Text('Request Method'),
              const SizedBox(height: 5),
              _requestMethodRow(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    var url = _url.text.trim();
    if (!_verifyEntry(url)) return;
    if (!url.startsWith('/')) url = '/$url';

    final cubit = context.read<EndpointsCubit>();
    if (widget.isEditing) {
      final previous = cubit.state.endpoints[widget.editIndex!];
      cubit.updateEndpoint(
        widget.editIndex!,
        previous.copyWith(title: _title.text, url: url, type: _requestType),
      );
    } else {
      cubit.addEndpoint(ApiEndpoint(
        title: _title.text,
        url: url,
        type: _requestType,
        result: const {},
        errorResult: const {},
        requestBody: const {},
        headers: const {},
      ));
    }
    Navigator.pop(context);
  }

  bool _verifyEntry(String url) {
    final cubit = context.read<EndpointsCubit>();

    if (_title.text.trim().isEmpty) {
      Dialogs.alert(context,
          title: AppStrings.emptyTitleDialogTitle,
          message: AppStrings.emptyTitleDialogMessage);
      return false;
    }
    if (url.isEmpty) {
      if (cubit.state.endpoints.isEmpty) {
        _url.text = '/';
        return true;
      }
      Dialogs.alert(context,
          title: AppStrings.emptyUrlDialogTitle,
          message: AppStrings.emptyUrlDialogMessage);
      return false;
    }
    if (url.contains(' ')) {
      Dialogs.alert(context,
          title: AppStrings.wrongUrlDialogTitle,
          message: AppStrings.wrongUrlDialogMessage);
      return false;
    }
    final normalizedUrl = url.startsWith('/') ? url : '/$url';
    if (cubit.isDuplicate(normalizedUrl, _requestType,
        excludingIndex: widget.editIndex)) {
      Dialogs.alert(context,
          title: AppStrings.endpointExistsDialogTitle,
          message: AppStrings.endpointExistsDialogMessage);
      return false;
    }
    return true;
  }

  Widget _requestMethodRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          RequestType.all.map((type) => _requestMethodButton(type)).toList(),
    );
  }

  Widget _requestMethodButton(String type) {
    final isSelected = type == _requestType;
    return InkWell(
      onTap: () => setState(() => _requestType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: const Offset(2, 2),
              color: Colors.black.withValues(alpha: 0.25),
            )
          ],
        ),
        child: Text(
          type,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
