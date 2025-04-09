// conversion_repository.dart

import 'dart:convert';
import 'package:er_diagram_app/features/data/models/database_schema.dart';
import '../models/relationship.dart';

class ConversionRepository {
  // Convert ER diagram to Relational Schema
  String convertToRelationalSchema(DatabaseSchema schema) {
    final StringBuffer buffer = StringBuffer();
    
    // Process each entity
    for (final entity in schema.entities) {
      buffer.writeln('${entity.name} (');
      
      // Add attributes
      final attributes = entity.attributes.map((attr) {
        String attrStr = attr.name;
        
        if (attr.isPrimaryKey) {
          attrStr += ' [PK]';
        }
        
        if (attr.isUnique) {
          attrStr += ' [UQ]';
        }
        
        attrStr += ': ${attr.type}';
        
        if (!attr.isNullable) {
          attrStr += ' NOT NULL';
        }
        
        return attrStr;
      }).join(',\n  ');
      
      buffer.writeln('  $attributes');
      
      // Add foreign keys from relationships
      final entityRelationships = schema.relationships.where(
        (rel) => rel.entityId1 == entity.id || rel.entityId2 == entity.id
      );
      
      for (final rel in entityRelationships) {
        // Only add FK to the "many" side
        if ((rel.type == RelationshipType.oneToMany && rel.entityId2 == entity.id) ||
            rel.type == RelationshipType.manyToMany) {
          
          // Get the other entity
          final otherEntityId = rel.entityId1 == entity.id ? rel.entityId2 : rel.entityId1;
          final otherEntity = schema.entities.firstWhere((e) => e.id == otherEntityId);
          
          // Get primary key of the other entity
          final primaryKey = otherEntity.attributes.firstWhere((attr) => attr.isPrimaryKey);
          
          buffer.writeln('  ${otherEntity.name.toLowerCase()}_${primaryKey.name} [FK to ${otherEntity.name}.${primaryKey.name}]');
        }
      }
      
      buffer.writeln(')\n');
    }
    
    // Handle many-to-many relationships by creating junction tables
    for (final rel in schema.relationships.where((r) => r.type == RelationshipType.manyToMany)) {
      final entity1 = schema.entities.firstWhere((e) => e.id == rel.entityId1);
      final entity2 = schema.entities.firstWhere((e) => e.id == rel.entityId2);
      
      final pk1 = entity1.attributes.firstWhere((attr) => attr.isPrimaryKey);
      final pk2 = entity2.attributes.firstWhere((attr) => attr.isPrimaryKey);
      
      buffer.writeln('${entity1.name}_${entity2.name} (');
      buffer.writeln('  ${entity1.name.toLowerCase()}_${pk1.name} [PK, FK to ${entity1.name}.${pk1.name}],');
      buffer.writeln('  ${entity2.name.toLowerCase()}_${pk2.name} [PK, FK to ${entity2.name}.${pk2.name}]');
      buffer.writeln(')\n');
    }
    
    return buffer.toString();
  }
  
  // Convert ER diagram to SQL
  String convertToSql(DatabaseSchema schema) {
    final StringBuffer buffer = StringBuffer();
    
    // Create tables for entities
    for (final entity in schema.entities) {
      buffer.writeln('CREATE TABLE ${entity.name} (');
      
      // Add columns
      final columns = <String>[];
      for (final attr in entity.attributes) {
        String column = '  ${attr.name} ${_getSqlType(attr.type)}';
        
        if (!attr.isNullable) {
          column += ' NOT NULL';
        }
        
        if (attr.isPrimaryKey) {
          column += ' PRIMARY KEY';
        }
        
        if (attr.isUnique && !attr.isPrimaryKey) {
          column += ' UNIQUE';
        }
        
        if (attr.defaultValue != null) {
          column += ' DEFAULT ${attr.defaultValue}';
        }
        
        columns.add(column);
      }
      
      // Add foreign key constraints
      for (final rel in schema.relationships.where((r) => 
        (r.entityId2 == entity.id && r.type == RelationshipType.oneToMany) || 
        (r.entityId1 == entity.id && r.type == RelationshipType.oneToOne)
      )) {
        final otherEntityId = rel.entityId1 == entity.id ? rel.entityId2 : rel.entityId1;
        final otherEntity = schema.entities.firstWhere((e) => e.id == otherEntityId);
        final otherPk = otherEntity.attributes.firstWhere((a) => a.isPrimaryKey);
        
        // Add the foreign key column
        columns.add('  ${otherEntity.name.toLowerCase()}_${otherPk.name} ${_getSqlType(otherPk.type)}');
        
        // Add the constraint
        columns.add('  FOREIGN KEY (${otherEntity.name.toLowerCase()}_${otherPk.name}) ' 'REFERENCES ${otherEntity.name}(${otherPk.name})');
      }
      
      buffer.writeln(columns.join(',\n'));
      buffer.writeln(');\n');
    }
    
    // Create junction tables for many-to-many relationships
    for (final rel in schema.relationships.where((r) => r.type == RelationshipType.manyToMany)) {
      final entity1 = schema.entities.firstWhere((e) => e.id == rel.entityId1);
      final entity2 = schema.entities.firstWhere((e) => e.id == rel.entityId2);
      
      final pk1 = entity1.attributes.firstWhere((a) => a.isPrimaryKey);
      final pk2 = entity2.attributes.firstWhere((a) => a.isPrimaryKey);
      
      buffer.writeln('CREATE TABLE ${entity1.name}_${entity2.name} (');
      buffer.writeln('  ${entity1.name.toLowerCase()}_${pk1.name} ${_getSqlType(pk1.type)},');
      buffer.writeln('  ${entity2.name.toLowerCase()}_${pk2.name} ${_getSqlType(pk2.type)},');
      buffer.writeln('  PRIMARY KEY (${entity1.name.toLowerCase()}_${pk1.name}, ${entity2.name.toLowerCase()}_${pk2.name}),');
      buffer.writeln('  FOREIGN KEY (${entity1.name.toLowerCase()}_${pk1.name}) REFERENCES ${entity1.name}(${pk1.name}),');
      buffer.writeln('  FOREIGN KEY (${entity2.name.toLowerCase()}_${pk2.name}) REFERENCES ${entity2.name}(${pk2.name})');
      buffer.writeln(');\n');
    }
    
    return buffer.toString();
  }
  
  // Helper for SQL type conversion
  String _getSqlType(String type) {
    switch (type.toUpperCase()) {
      case 'INT':
      case 'INTEGER':
        return 'INTEGER';
      case 'VARCHAR':
      case 'STRING':
      case 'TEXT':
        return 'TEXT';
      case 'FLOAT':
      case 'DOUBLE':
      case 'REAL':
        return 'REAL';
      case 'BOOLEAN':
      case 'BOOL':
        return 'BOOLEAN';
      case 'DATETIME':
      case 'TIMESTAMP':
        return 'TIMESTAMP';
      case 'DATE':
        return 'DATE';
      case 'BLOB':
      case 'BINARY':
        return 'BLOB';
      default:
        return type;
    }
  }
  
  // Convert ER diagram to JSON Schema
  String convertToJson(DatabaseSchema schema) {
    final Map<String, dynamic> jsonSchema = {
      'schema': {
        'name': schema.name,
        'entities': schema.entities.map((entity) {
          return {
            'name': entity.name,
            'attributes': entity.attributes.map((attr) {
              return {
                'name': attr.name,
                'type': attr.type,
                'isPrimaryKey': attr.isPrimaryKey,
                'isNullable': attr.isNullable,
                'isUnique': attr.isUnique,
                'defaultValue': attr.defaultValue,
              };
            }).toList(),
          };
        }).toList(),
        'relationships': schema.relationships.map((rel) {
          final entity1 = schema.entities.firstWhere((e) => e.id == rel.entityId1);
          final entity2 = schema.entities.firstWhere((e) => e.id == rel.entityId2);
          
          return {
            'name': rel.name,
            'type': rel.type.toString().split('.').last,
            'cardinality': rel.cardinality.toString().split('.').last,
            'entity1': entity1.name,
            'entity2': entity2.name,
          };
        }).toList(),
      }
    };
    
    return JsonEncoder.withIndent('  ').convert(jsonSchema);
  }
  
  // Convert ER diagram to Dart classes
  String convertToDart(DatabaseSchema schema) {
    final StringBuffer buffer = StringBuffer();
    
    buffer.writeln("// Generated Dart model classes from ER diagram");
    buffer.writeln("// Generated on: ${DateTime.now().toIso8601String()}");
    buffer.writeln();
    
    // Add imports
    buffer.writeln("import 'dart:convert';");
    buffer.writeln();
    
    // Create a class for each entity
    for (final entity in schema.entities) {
      buffer.writeln("class ${entity.name} {");
      
      // Define fields
      for (final attr in entity.attributes) {
        String dartType = _getDartType(attr.type);
        
        // Make nullable if needed
        if (attr.isNullable) {
          dartType += '?';
        }
        
        buffer.writeln("  $dartType ${attr.name};");
      }
      
      // Add relationships as fields
      for (final rel in schema.relationships.where((r) => r.entityId1 == entity.id || r.entityId2 == entity.id)) {
        final otherEntityId = rel.entityId1 == entity.id ? rel.entityId2 : rel.entityId1;
        final otherEntity = schema.entities.firstWhere((e) => e.id == otherEntityId);
        
        if (rel.type == RelationshipType.oneToMany) {
          if (rel.entityId1 == entity.id) {
            // One-to-many: parent side gets a list
            buffer.writeln("  List<${otherEntity.name}>? ${otherEntity.name.toLowerCase()}s;");
          } else {
            // One-to-many: child side gets a reference
            buffer.writeln("  ${otherEntity.name}? ${otherEntity.name.toLowerCase()};");
          }
        } else if (rel.type == RelationshipType.oneToOne) {
          buffer.writeln("  ${otherEntity.name}? ${otherEntity.name.toLowerCase()};");
        } else if (rel.type == RelationshipType.manyToMany) {
          buffer.writeln("  List<${otherEntity.name}>? ${otherEntity.name.toLowerCase()}s;");
        }
      }
      
      buffer.writeln();
      
      // Constructor
      buffer.writeln("  ${entity.name}({");
      for (final attr in entity.attributes) {
        final required = !attr.isNullable && attr.defaultValue == null ? 'required ' : '';
        buffer.writeln("    ${required}this.${attr.name},");
      }
      buffer.writeln("  });");
      
      buffer.writeln();
      buffer.writeln("  factory ${entity.name}.fromJson(Map<String, dynamic> json) {");
      buffer.writeln("    return ${entity.name}(");
      for (final attr in entity.attributes) {
        final String dartType = _getDartType(attr.type);
        String conversion = "json['${attr.name}']";
        
        // Add type conversion if needed
        if (dartType == 'int') {
          conversion = "json['${attr.name}'] != null ? int.parse(json['${attr.name}'].toString()) : null";
        } else if (dartType == 'double') {
          conversion = "json['${attr.name}'] != null ? double.parse(json['${attr.name}'].toString()) : null";
        } else if (dartType == 'bool') {
          conversion = "json['${attr.name}'] != null ? json['${attr.name}'] == true || json['${attr.name}'] == 'true' : null";
        } else if (dartType == 'DateTime') {
          conversion = "json['${attr.name}'] != null ? DateTime.parse(json['${attr.name}']) : null";
        }
        
        buffer.writeln("      ${attr.name}: $conversion,");
      }
      buffer.writeln("    );");
      buffer.writeln("  }");
      
      buffer.writeln();
      
      // toJson method
      buffer.writeln("  Map<String, dynamic> toJson() {");
      buffer.writeln("    return {");
      for (final attr in entity.attributes) {
        buffer.writeln("      '${attr.name}': ${attr.name},");
      }
      buffer.writeln("    };");
      buffer.writeln("  }");
      
      buffer.writeln("}");
      buffer.writeln();
    }
    
    return buffer.toString();
  }
  
  // Helper for Dart type conversion
  String _getDartType(String type) {
    switch (type.toUpperCase()) {
      case 'INT':
      case 'INTEGER':
        return 'int';
      case 'VARCHAR':
      case 'STRING':
      case 'TEXT':
        return 'String';
      case 'FLOAT':
      case 'DOUBLE':
      case 'REAL':
        return 'double';
      case 'BOOLEAN':
      case 'BOOL':
        return 'bool';
      case 'DATETIME':
      case 'TIMESTAMP':
        return 'DateTime';
      case 'DATE':
        return 'DateTime';
      case 'BLOB':
      case 'BINARY':
        return 'List<int>';
      default:
        return 'dynamic';
    }
  }
}