// relationship.dart
class Relationship {
  final String id;
  final String name;
  final String entityId1;
  final String entityId2;
  final RelationshipType type;
  final RelationshipCardinality cardinality;
  
  Relationship({
    required this.id,
    required this.name,
    required this.entityId1,
    required this.entityId2,
    required this.type,
    required this.cardinality,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'entityId1': entityId1,
      'entityId2': entityId2,
      'type': type.toString(),
      'cardinality': cardinality.toString(),
    };
  }
  
  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      id: json['id'],
      name: json['name'],
      entityId1: json['entityId1'],
      entityId2: json['entityId2'],
      type: RelationshipType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => RelationshipType.oneToMany,
      ),
      cardinality: RelationshipCardinality.values.firstWhere(
        (e) => e.toString() == json['cardinality'],
        orElse: () => RelationshipCardinality.mandatory,
      ),
    );
  }
}

enum RelationshipType {
  oneToOne,
  oneToMany,
  manyToMany,
}

enum RelationshipCardinality {
  mandatory,
  optional,
}