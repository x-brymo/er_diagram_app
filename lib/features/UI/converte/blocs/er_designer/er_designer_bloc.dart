// er_designer_bloc.dart
import 'package:er_diagram_app/features/UI/converte/blocs/er_designer/er_designer_event.dart';
import 'package:er_diagram_app/features/UI/converte/blocs/er_designer/er_designer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ERDesignerBloc extends Bloc<ERDesignerEvent, ERDesignerState> {
  ERDesignerBloc() : super(ERDesignerLoaded(entities: [], relationships: [])) {
    on<LoadDiagram>(_onLoadDiagram);
    on<AddEntity>(_onAddEntity);
    on<UpdateEntity>(_onUpdateEntity);
    on<DeleteEntity>(_onDeleteEntity);
    on<AddRelationship>(_onAddRelationship);
    on<UpdateRelationship>(_onUpdateRelationship);
    on<DeleteRelationship>(_onDeleteRelationship);
    on<SaveDiagram>(_onSaveDiagram);
  }
  
  void _onLoadDiagram(LoadDiagram event, Emitter<ERDesignerState> emit) async {
    // Logic to load a diagram
  }
  
  void _onAddEntity(AddEntity event, Emitter<ERDesignerState> emit) {
    final currentState = state;
    if (currentState is ERDesignerLoaded) {
      emit(ERDesignerLoaded(
        entities: [...currentState.entities, event.entity],
        relationships: currentState.relationships,
      ));
    }
  }
  
  void _onUpdateEntity(UpdateEntity event, Emitter<ERDesignerState> emit) {
    final currentState = state;
    if (currentState is ERDesignerLoaded) {
      final updatedEntities = currentState.entities.map((entity) {
        return entity.id == event.entity.id ? event.entity : entity;
      }).toList();
      
      emit(ERDesignerLoaded(
        entities: updatedEntities,
        relationships: currentState.relationships,
      ));
    }
  }
  
  void _onDeleteEntity(DeleteEntity event, Emitter<ERDesignerState> emit) {
    final currentState = state;
    if (currentState is ERDesignerLoaded) {
      // Remove entity
      final updatedEntities = currentState.entities
          .where((entity) => entity.id != event.entityId)
          .toList();
      
      // Remove relationships associated with this entity
      final updatedRelationships = currentState.relationships
          .where((rel) => rel.entityId1 != event.entityId && rel.entityId2 != event.entityId)
          .toList();
      
      emit(ERDesignerLoaded(
        entities: updatedEntities,
        relationships: updatedRelationships,
      ));
    }
  }
  
  void _onAddRelationship(AddRelationship event, Emitter<ERDesignerState> emit) {
    final currentState = state;
    if (currentState is ERDesignerLoaded) {
      emit(ERDesignerLoaded(
        entities: currentState.entities,
        relationships: [...currentState.relationships, event.relationship],
      ));
    }
  }
  
  void _onUpdateRelationship(UpdateRelationship event, Emitter<ERDesignerState> emit) {
    final currentState = state;
    if (currentState is ERDesignerLoaded) {
      final updatedRelationships = currentState.relationships.map((rel) {
        return rel.id == event.relationship.id ? event.relationship : rel;
      }).toList();
      
      emit(ERDesignerLoaded(
        entities: currentState.entities,
        relationships: updatedRelationships,
      ));
    }
  }
  
  void _onDeleteRelationship(DeleteRelationship event, Emitter<ERDesignerState> emit) {
    final currentState = state;
    if (currentState is ERDesignerLoaded) {
      final updatedRelationships = currentState.relationships
          .where((rel) => rel.id != event.relationshipId)
          .toList();
      
      emit(ERDesignerLoaded(
        entities: currentState.entities,
        relationships: updatedRelationships,
      ));
    }
  }
  
  void _onSaveDiagram(SaveDiagram event, Emitter<ERDesignerState> emit) async {
    // Logic to save diagram
  }
}