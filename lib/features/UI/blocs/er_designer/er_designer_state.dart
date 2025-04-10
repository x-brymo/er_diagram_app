// er_designer_state.dart
import '../../../data/models/relationship.dart';
import '../../../domain/entity/entity.dart';

abstract class ERDesignerState {}

class ERDesignerLoading extends ERDesignerState {}

class ERDesignerLoaded extends ERDesignerState {
  final List<Entity> entities;
  final List<Relationship> relationships;
  
  ERDesignerLoaded({
    required this.entities,
    required this.relationships,
  });
}

class ERDesignerError extends ERDesignerState {
  final String message;
  
  ERDesignerError(this.message);
}