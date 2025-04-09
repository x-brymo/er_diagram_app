// home_view.dart
import 'package:er_diagram_app/features/UI/converte/view/converter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:er_diagram_app/core/utils/responsive_utils.dart';

import '../../../core/config/enum.dart';
import '../converte/blocs/home/home_bloc.dart';
import '../converte/view/file_import_view.dart';
import '../layout/er_designer_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ER Diagram Designer'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to ER Diagram Designer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: responsive.isMobile ? 1 : (responsive.isTablet ? 2 : 3),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    'Design ER Diagram',
                    'Create entity relationship diagrams visually',
                    Icons.design_services,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ERDesignerView()),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Convert to RS',
                    'Convert ER diagram to Relational Schema',
                    Icons.transform,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>  ConverterView(
                          conversionType: ConversionType.erToRs,
                        ),
                      ),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Generate SQL',
                    'Create SQL from your ER diagram',
                    Icons.code,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConverterView(
                          conversionType: ConversionType.erToSql,
                        ),
                      ),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Generate JSON',
                    'Export your schema as JSON',
                    Icons.data_object,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConverterView(
                          conversionType: ConversionType.erToJson,
                        ),
                      ),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Generate Dart Classes',
                    'Create Dart models from your schema',
                    Icons.code,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConverterView(
                          conversionType: ConversionType.erToDart,
                        ),
                      ),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    'Import Diagram',
                    'Import from Draw.io and other formats',
                    Icons.upload_file,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FileImportView()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

