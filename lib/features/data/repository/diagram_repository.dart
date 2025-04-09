// diagram_repository.dart
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../domain/entity/entity.dart';
import '../models/database_schema.dart';
import '../models/relationship.dart';
import '../service/storage_service.dart';

class DiagramRepository {
  final StorageService _storageService;
  
  DiagramRepository(this._storageService);
  
  Future<String> saveDiagram({
    String? id,
    required String name,
    required List<Entity> entities,
    required List<Relationship> relationships,
  }) async {
    final diagramId = id ?? const Uuid().v4();
    
    final data = jsonEncode({
      'entities': entities.map((e) => e.toJson()).toList(),
      'relationships': relationships.map((r) => r.toJson()).toList(),
    });
    
    await _storageService.saveDiagram(diagramId, name, data);
    return diagramId;
  }
  
  Future<DatabaseSchema?> getDiagram(String id) async {
    final data = await _storageService.getDiagram(id);
    
    if (data != null) {
      final Map<String, dynamic> jsonData = jsonDecode(data['data']);
      
      final entities = (jsonData['entities'] as List)
          .map((e) => Entity.fromJson(e))
          .toList();
          
      final relationships = (jsonData['relationships'] as List)
          .map((r) => Relationship.fromJson(r))
          .toList();
      
      return DatabaseSchema(
        id: data['id'],
        name: data['name'],
        entities: entities,
        relationships: relationships,
        createdAt: DateTime.fromMillisecondsSinceEpoch(data['created_at']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updated_at']),
      );
    }
    
    return null;
  }
  
  Future<List<Map<String, dynamic>>> getAllDiagrams() async {
    return await _storageService.getAllDiagrams();
  }
  
  Future<void> deleteDiagram(String id) async {
    await _storageService.deleteDiagram(id);
  }
}