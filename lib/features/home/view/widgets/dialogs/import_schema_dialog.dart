import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaml/yaml.dart';

import 'package:api_server/core/constants/app_strings.dart';
import 'package:api_server/data/models/api_endpoint.dart';
import 'package:api_server/data/openapi/open_api_parser.dart';
import 'package:api_server/features/home/cubit/endpoints_cubit.dart';
import 'package:api_server/features/home/cubit/endpoints_state.dart';
import 'package:api_server/features/home/view/widgets/endpoint_method_chip.dart';

enum _Stage { pickFile, loading, error, preview, done }

/// Lets the user pick an OpenAPI (Swagger) spec file, previews the
/// endpoints it would generate, and imports the ones the user selects.
class ImportSchemaDialog extends StatefulWidget {
  const ImportSchemaDialog({super.key});

  @override
  State<ImportSchemaDialog> createState() => _ImportSchemaDialogState();
}

class _ImportSchemaDialogState extends State<ImportSchemaDialog> {
  _Stage _stage = _Stage.pickFile;
  String? _errorMessage;
  List<ApiEndpoint> _parsedEndpoints = [];
  final Set<int> _selected = {};
  ImportSummary? _summary;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 520,
          height: 480,
          child: _buildStage(),
        ),
      ),
    );
  }

  Widget _buildStage() {
    switch (_stage) {
      case _Stage.pickFile:
        return _PickFileView(onPick: _pickAndParseFile);
      case _Stage.loading:
        return const Center(child: CircularProgressIndicator());
      case _Stage.error:
        return _ErrorView(
          message: _errorMessage ?? 'Something went wrong',
          onRetry: () => setState(() => _stage = _Stage.pickFile),
        );
      case _Stage.preview:
        return _PreviewView(
          endpoints: _parsedEndpoints,
          selected: _selected,
          onToggle: (index) => setState(() {
            if (!_selected.remove(index)) _selected.add(index);
          }),
          onToggleAll: (selectAll) => setState(() {
            _selected
              ..clear()
              ..addAll(selectAll
                  ? List.generate(_parsedEndpoints.length, (i) => i)
                  : const []);
          }),
          onCancel: () => Navigator.pop(context),
          onImport: _importSelected,
        );
      case _Stage.done:
        return _DoneView(
          summary: _summary!,
          onClose: () => Navigator.pop(context),
        );
    }
  }

  Future<void> _pickAndParseFile() async {
    setState(() => _stage = _Stage.loading);
    try {
      final result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['json', 'yaml', 'yml'],
      );
      if (result == null || result.files.isEmpty) {
        setState(() => _stage = _Stage.pickFile);
        return;
      }

      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        throw StateError(AppStrings.importNoFileSelected);
      }

      final spec = _decodeSpec(fileName: file.name, bytes: bytes);
      final endpoints = OpenApiParser.parse(spec);

      if (endpoints.isEmpty) {
        throw StateError(AppStrings.importNoEndpointsFound);
      }

      setState(() {
        _parsedEndpoints = endpoints;
        _selected
          ..clear()
          ..addAll(List.generate(endpoints.length, (i) => i));
        _stage = _Stage.preview;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _stage = _Stage.error;
      });
    }
  }

  Map _decodeSpec({required String fileName, required Uint8List bytes}) {
    final isYaml = fileName.endsWith('.yaml') || fileName.endsWith('.yml');
    final content = utf8.decode(bytes);
    final decoded = isYaml ? loadYaml(content) : jsonDecode(content);
    final converted = OpenApiParser.deepConvert(decoded);
    if (converted is! Map) {
      throw const FormatException('The selected file is not a valid OpenAPI document');
    }
    return converted;
  }

  void _importSelected() {
    final selectedEndpoints = _selected
        .toList()
      ..sort();
    final endpoints =
        selectedEndpoints.map((i) => _parsedEndpoints[i]).toList();
    final summary = context.read<EndpointsCubit>().addEndpoints(endpoints);
    setState(() {
      _summary = summary;
      _stage = _Stage.done;
    });
  }
}

class _PickFileView extends StatelessWidget {
  const _PickFileView({required this.onPick});

  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.file_upload_outlined,
              size: 48, color: Theme.of(context).primaryColor),
          const SizedBox(height: 16),
          const Text(
            'Select an OpenAPI (Swagger) spec file',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            '.json, .yaml, or .yml',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.folder_open),
            label: const Text('Choose file'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text(AppStrings.importParseErrorTitle,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewView extends StatelessWidget {
  const _PreviewView({
    required this.endpoints,
    required this.selected,
    required this.onToggle,
    required this.onToggleAll,
    required this.onCancel,
    required this.onImport,
  });

  final List<ApiEndpoint> endpoints;
  final Set<int> selected;
  final ValueChanged<int> onToggle;
  final ValueChanged<bool> onToggleAll;
  final VoidCallback onCancel;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final allSelected = selected.length == endpoints.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${endpoints.length} endpoint${endpoints.length == 1 ? '' : 's'} found',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        CheckboxListTile(
          value: allSelected,
          onChanged: (value) => onToggleAll(value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Select all'),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: endpoints.length,
            itemBuilder: (context, index) {
              final endpoint = endpoints[index];
              return CheckboxListTile(
                value: selected.contains(index),
                onChanged: (_) => onToggle(index),
                dense: true,
                title: Row(
                  children: [
                    EndpointMethodChip(type: endpoint.type),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(endpoint.title, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                subtitle: Text(endpoint.url, style: const TextStyle(fontSize: 11)),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: onCancel, child: const Text('Cancel')),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: selected.isEmpty ? null : onImport,
              child: Text('Import (${selected.length})'),
            ),
          ],
        ),
      ],
    );
  }
}

class _DoneView extends StatelessWidget {
  const _DoneView({required this.summary, required this.onClose});

  final ImportSummary summary;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
          const SizedBox(height: 16),
          Text(
            'Imported ${summary.imported} endpoint${summary.imported == 1 ? '' : 's'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          if (summary.skipped > 0) ...[
            const SizedBox(height: 6),
            Text(
              '${summary.skipped} skipped as duplicates of existing endpoints',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
          const SizedBox(height: 20),
          ElevatedButton(onPressed: onClose, child: const Text('Done')),
        ],
      ),
    );
  }
}
