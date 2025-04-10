// er_designer_view.dart (simplified version)
import 'package:er_diagram_app/features/UI/blocs/er_designer/er_designer_event.dart';
import 'package:er_diagram_app/features/UI/blocs/er_designer/er_designer_state.dart';
import 'package:er_diagram_app/features/UI/converte/widgets/entity_component.dart';
import 'package:er_diagram_app/features/domain/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:er_diagram_app/core/utils/responsive_utils.dart';
import 'package:uuid/uuid.dart';

import '../blocs/er_designer/er_designer_bloc.dart';
import '../converte/widgets/relationship_component.dart';

class ERDesignerView extends StatefulWidget {
  const ERDesignerView({super.key});

  @override
  State<ERDesignerView> createState() => _ERDesignerViewState();
}

class _ERDesignerViewState extends State<ERDesignerView> {
  final TransformationController _transformationController = TransformationController();
  
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    
    return BlocProvider(
      create: (context) => ERDesignerBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ER Diagram Designer'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                // Save diagram logic
              },
            ),
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () {
                // Export diagram logic
              },
            ),
          ],
        ),
        body: BlocBuilder<ERDesignerBloc, ERDesignerState>(
          builder: (context, state) {
            if (state is ERDesignerLoaded) {
              return Row(
                children: [
                  // Tools sidebar
                  if (!responsive.isMobile)
                    Container(
                      width: 250,
                      color: Theme.of(context).colorScheme.surface,
                      child: _buildToolbar(context),
                    ),
                  
                  // Main design area
                  Expanded(
                    child: Stack(
                      children: [
                        // Diagram canvas
                        InteractiveViewer(
                          transformationController: _transformationController,
                          minScale: 0.5,
                          maxScale: 2.5,
                          child: Stack(
                            children: [
                              // Background grid
                              Container(
                                width: 3000,
                                height: 3000,
                                color: Theme.of(context).scaffoldBackgroundColor,
                                child: CustomPaint(
                                  painter: GridPainter(),
                                ),
                              ),
                              
                              // Entities
                              ...state.entities.map((entity) => EntityComponent(
                                entity: entity,
                                onUpdate: (updatedEntity) {
                                  context.read<ERDesignerBloc>().add(
                                    UpdateEntity(updatedEntity),
                                  );
                                },
                              )),
                              
                              // Relationships
                              ...state.relationships.map((relationship) => RelationshipComponent(
                                relationship: relationship,
                                entities: state.entities,
                                onUpdate: (updatedRelationship) {
                                  context.read<ERDesignerBloc>().add(
                                    UpdateRelationship(updatedRelationship),
                                  );
                                },
                              )),
                            ],
                          ),
                        ),
                        
                        // Mobile toolbar at bottom
                        if (responsive.isMobile)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 80,
                              color: Theme.of(context).colorScheme.surface,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                children: [
                                  _buildToolButton(
                                    context,
                                    'Entity',
                                    Icons.table_chart,
                                    () => _addEntity(context),
                                  ),
                                  _buildToolButton(
                                    context,
                                    'Relationship',
                                    Icons.compare_arrows,
                                    () => _addRelationship(context),
                                  ),
                                  _buildToolButton(
                                    context,
                                    'Save',
                                    Icons.save,
                                    () {},
                                  ),
                                  _buildToolButton(
                                    context,
                                    'Export',
                                    Icons.file_download,
                                    () {},
                                  ),
                                  _buildToolButton(
                                    context,
                                    'Reset View',
                                    Icons.center_focus_strong,
                                    () {
                                      _transformationController.value = Matrix4.identity();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }
            
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: responsive.isMobile
            ? null
            : FloatingActionButton(
                onPressed: () => _addEntity(context),
                child: const Icon(Icons.add),
              ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Tools',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.table_chart),
          title: const Text('Add Entity'),
          onTap: () => _addEntity(context),
        ),
        ListTile(
          leading: const Icon(Icons.compare_arrows),
          title: const Text('Add Relationship'),
          onTap: () => _addRelationship(context),
        ),
        const Divider(),
        Text(
          'View',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.center_focus_strong),
          title: const Text('Reset View'),
          onTap: () {
            _transformationController.value = Matrix4.identity();
          },
        ),
        ListTile(
          leading: const Icon(Icons.zoom_in),
          title: const Text('Zoom In'),
          onTap: () {
            _transformationController.value = Matrix4.identity()..scale(1.1);
          },
        ),
        ListTile(
          leading: const Icon(Icons.zoom_out),
          title: const Text('Zoom Out'),
          onTap: () {
            _transformationController.value = Matrix4.identity()..scale(0.9);
          },
        ),
      ],
    );
  }

  Widget _buildToolButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(icon),
            onPressed: onTap,
          ),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _addEntity(BuildContext context) {
    final bloc = context.read<ERDesignerBloc>();
    
    // Calculate position in the middle of the viewport
    final entity = Entity(
      id: const Uuid().v4(),
      name: 'New Entity',
      attributes: [
        Attribute(
          name: 'id',
          type: 'INTEGER',
          isPrimaryKey: true,
          isNullable: false,
        ),
      ],
      position: Point(100, 100), // Default position, should calculate based on viewport
    );
    
    bloc.add(AddEntity(entity));
  }

  void _addRelationship(BuildContext context) {
    // Show dialog to select entities and relationship type
  }
}
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;
    
    const gridSize = 20.0;
    
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}