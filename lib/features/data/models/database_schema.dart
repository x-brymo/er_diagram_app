// database_schema.dart
import 'package:er_diagram_app/features/data/models/relationship.dart';

import '../../domain/entity/entity.dart';

class DatabaseSchema {
  final String id;
  final String name;
  final List<Entity> entities;
  final List<Relationship> relationships;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  DatabaseSchema({
    required this.id,
    required this.name,
    required this.entities,
    required this.relationships,
    required this.createdAt,
    required this.updatedAt,
  });
}