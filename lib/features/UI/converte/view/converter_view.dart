import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

import '../../../../core/config/enum.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../data/service/file_service.dart';
import '../../blocs/converter/converter_bloc.dart';
import '../../blocs/converter/converter_event.dart';
import '../../blocs/converter/converter_state.dart';

class ConverterView extends StatefulWidget {
  final ConversionType conversionType;
  
  const ConverterView({
    super.key,
    required this.conversionType,
  });

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _outputNameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _outputNameController.text = _getDefaultFileName();
  }
  
  String _getDefaultFileName() {
    switch (widget.conversionType) {
      case ConversionType.erToRs:
        return 'relational_schema';
      case ConversionType.erToSql:
        return 'schema.sql';
      case ConversionType.erToJson:
        return 'schema.json';
      case ConversionType.erToDart:
        return 'models.dart';
    }
  }
  
  String _getTitle() {
    switch (widget.conversionType) {
      case ConversionType.erToRs:
        return 'Convert to Relational Schema';
      case ConversionType.erToSql:
        return 'Generate SQL';
      case ConversionType.erToJson:
        return 'Generate JSON';
      case ConversionType.erToDart:
        return 'Generate Dart Classes';
    }
  }
  
  String _getSyntaxLanguage() {
    switch (widget.conversionType) {
      case ConversionType.erToRs:
        return 'text';
      case ConversionType.erToSql:
        return 'sql';
      case ConversionType.erToJson:
        return 'json';
      case ConversionType.erToDart:
        return 'dart';
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _outputNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    
    return BlocProvider(
      create: (context) => ConverterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle()),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Input'),
              Tab(text: 'Output'),
            ],
          ),
        ),
        body: BlocConsumer<ConverterBloc, ConverterState>(
          listener: (context, state) {
            if (state is ConversionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ConversionComplete) {
              _tabController.animateTo(1);
            }
          },
          builder: (context, state) {
            return TabBarView(
              controller: _tabController,
              children: [
                // Input tab
                _buildInputTab(context, state, responsive),
                
                // Output tab
                _buildOutputTab(context, state, responsive),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputTab(BuildContext context, ConverterState state, ResponsiveUtils responsive) {
    return Padding(
      padding: responsive.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select Source Diagram',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: state is ConversionLoading
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<Map<String, dynamic>>>(
                    future: context.read<ConverterBloc>().getAllDiagrams(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      
                      final diagrams = snapshot.data ?? [];
                      
                      if (diagrams.isEmpty) {
                        return const Center(
                          child: Text('No diagrams found. Create a diagram first.'),
                        );
                      }
                      
                      return ListView.builder(
                        itemCount: diagrams.length,
                        itemBuilder: (context, index) {
                          final diagram = diagrams[index];
                          return ListTile(
                            title: Text(diagram['name']),
                            subtitle: Text(
                              'Modified: ${DateTime.fromMillisecondsSinceEpoch(diagram['updated_at']).toString()}',
                            ),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              context.read<ConverterBloc>().add(
                                ConvertDiagram(
                                  diagramId: diagram['id'],
                                  conversionType: widget.conversionType.toString(),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: const Text('Import from File'),
            onPressed: () async {
              final fileService = context.read<FileService>();
              final file = await fileService.pickFile(
                allowedExtensions: ['xml', 'json', 'drawio'],
              );
              
              if (file != null) {
                // Process imported file
                // You would add the appropriate event here
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOutputTab(BuildContext context, ConverterState state, ResponsiveUtils responsive) {
    return Padding(
      padding: responsive.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _outputNameController,
                  decoration: const InputDecoration(
                    labelText: 'Output Filename',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                onPressed: state is ConversionComplete
                    ? () async {
                        final fileService = context.read<FileService>();
                        final success = await fileService.saveFile(
                          state.output,
                          _outputNameController.text,
                        );
                        
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('File saved successfully')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to save file')),
                          );
                        }
                      }
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: state is ConversionComplete
                ? SyntaxView(
                    code: state.output,
                    syntax: _getSyntaxLanguage() as Syntax,
                    syntaxTheme: SyntaxTheme.dracula(),
                    withZoom: true,
                    withLinesCount: true,
                  )
                : const Center(
                    child: Text('Select a diagram from the Input tab to begin conversion'),
                  ),
          ),
        ],
      ),
    );
  }
}