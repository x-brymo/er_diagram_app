// file_import_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:er_diagram_app/core/utils/responsive_utils.dart';

import '../../../data/service/file_service.dart';
import '../blocs/file_import/file_import_bloc.dart';
import '../blocs/file_import/file_import_event.dart';
import '../blocs/file_import/file_import_state.dart';

class FileImportView extends StatelessWidget {
  const FileImportView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    
    return BlocProvider(
      create: (context) => FileImportBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Import Diagram'),
        ),
        body: BlocConsumer<FileImportBloc, FileImportState>(
          listener: (context, state) {
            if (state is FileImportError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is FileImportSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File imported successfully')),
              );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: responsive.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Import section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Import from File',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Supported formats:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• Draw.io (.drawio, .xml)'),
                              Text('• JSON Schema (.json)'),
                              Text('• SQL script (.sql)'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: state is FileImportLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton.icon(
                                    icon: const Icon(Icons.upload_file),
                                    label: const Text('Select File to Import'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final fileService = context.read<FileService>();
                                      final file = await fileService.pickFile(
                                        allowedExtensions: ['xml', 'json', 'sql', 'drawio'],
                                      );
                                      
                                      if (file != null) {
                                        context.read<FileImportBloc>().add(
                                          ImportFile(file),
                                        );
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Import history section
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Imports',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: FutureBuilder<List<Map<String, dynamic>>>(
                                future: context.read<FileImportBloc>().getImportHistory(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  }
                                  
                                  final imports = snapshot.data ?? [];
                                  
                                  if (imports.isEmpty) {
                                    return const Center(
                                      child: Text('No import history'),
                                    );
                                  }
                                  
                                  return ListView.builder(
                                    itemCount: imports.length,
                                    itemBuilder: (context, index) {
                                      final import = imports[index];
                                      return ListTile(
                                        leading: const Icon(Icons.history),
                                        title: Text(import['filename']),
                                        subtitle: Text(
                                          'Imported: ${DateTime.fromMillisecondsSinceEpoch(import['timestamp']).toString()}',
                                        ),
                                        trailing: const Icon(Icons.arrow_forward),
                                        onTap: () {
                                          // Open the imported diagram
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}