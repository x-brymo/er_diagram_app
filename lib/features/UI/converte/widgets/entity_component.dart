// entity_component.dart
import 'package:flutter/material.dart';

import '../../../domain/entity/entity.dart';

class EntityComponent extends StatefulWidget {
  final Entity entity;
  final Function(Entity) onUpdate;
  
  const EntityComponent({
    super.key,
    required this.entity,
    required this.onUpdate,
  });

  @override
  State<EntityComponent> createState() => _EntityComponentState();
}

class _EntityComponentState extends State<EntityComponent> {
  late Offset position;
  
  @override
  void initState() {
    super.initState();
    position = Offset(widget.entity.position.x, widget.entity.position.y);
  }
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position = Offset(
              position.dx + details.delta.dx,
              position.dy + details.delta.dy,
            );
          });
          
          // Update entity position
          final updatedEntity = Entity(
            id: widget.entity.id,
            name: widget.entity.name,
            attributes: widget.entity.attributes,
            position: Point(position.dx, position.dy),
          );
          
          widget.onUpdate(updatedEntity);
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Entity name
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                child: Text(
                  widget.entity.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Divider
              const Divider(height: 1, thickness: 1),
              
              // Attributes
              Container(
                color: Colors.white,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.entity.attributes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final attr = widget.entity.attributes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          if (attr.isPrimaryKey)
                            const Icon(Icons.key, size: 16, color: Colors.amber),
                          if (attr.isUnique && !attr.isPrimaryKey)
                            const Icon(Icons.fiber_pin, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              attr.name,
                              style: TextStyle(
                                fontWeight: attr.isPrimaryKey || attr.isUnique
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Text(
                            attr.type,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}