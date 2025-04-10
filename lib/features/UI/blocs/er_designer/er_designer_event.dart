// er_designer_event.dart
import '../../../data/models/relationship.dart';
import '../../../domain/entity/entity.dart';

abstract class ERDesignerEvent {}

class LoadDiagram extends ERDesignerEvent {
  final String diagramId;
  
  LoadDiagram(this.diagramId);
}

class AddEntity extends ERDesignerEvent {
  final Entity entity;
  
  AddEntity(this.entity);
}

class UpdateEntity extends ERDesignerEvent {
  final Entity entity;
  
  UpdateEntity(this.entity);
}

class DeleteEntity extends ERDesignerEvent {
  final String entityId;
  
  DeleteEntity(this.entityId);
}

class AddRelationship extends ERDesignerEvent {
  final Relationship relationship;
  
  AddRelationship(this.relationship);
}

class UpdateRelationship extends ERDesignerEvent {
  final Relationship relationship;
  
  UpdateRelationship(this.relationship);
}

class DeleteRelationship extends ERDesignerEvent {
  final String relationshipId;
  
  DeleteRelationship(this.relationshipId);
}

class SaveDiagram extends ERDesignerEvent {
  final String name;
  
  SaveDiagram(this.name);
}