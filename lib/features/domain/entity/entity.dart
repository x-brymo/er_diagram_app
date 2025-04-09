// entity.dart (data model)
class Entity {
  final String id;
  final String name;
  final List<Attribute> attributes;
  final Point position;
  
  Entity({
    required this.id,
    required this.name,
    required this.attributes,
    required this.position,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'attributes': attributes.map((a) => a.toJson()).toList(),
      'position': {
        'x': position.x,
        'y': position.y,
      },
    };
  }
  
  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['id'],
      name: json['name'],
      attributes: (json['attributes'] as List)
          .map((a) => Attribute.fromJson(a))
          .toList(),
      position: Point(
        json['position']['x'],
        json['position']['y'],
      ),
    );
  }
}
class Point {
  final double x;
  final double y;
  
  Point(this.x, this.y);
}

class Attribute {
  final String name;
  final String type;
  final bool isPrimaryKey;
  final bool isNullable;
  final bool isUnique;
  final String? defaultValue;
  
  Attribute({
    required this.name,
    required this.type,
    this.isPrimaryKey = false,
    this.isNullable = true,
    this.isUnique = false,
    this.defaultValue,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'isPrimaryKey': isPrimaryKey,
      'isNullable': isNullable,
      'isUnique': isUnique,
      'defaultValue': defaultValue,
    };
  }
  
  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: json['name'],
      type: json['type'],
      isPrimaryKey: json['isPrimaryKey'] ?? false,
      isNullable: json['isNullable'] ?? true,
      isUnique: json['isUnique'] ?? false,
      defaultValue: json['defaultValue'],
    );
  }
}
