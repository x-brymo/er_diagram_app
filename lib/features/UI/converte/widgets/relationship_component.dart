import 'package:flutter/material.dart';
import 'package:er_diagram_app/features/domain/entity/entity.dart';

import '../../../data/models/relationship.dart';

class RelationshipComponent extends StatelessWidget {
  final Relationship relationship;
  final List<Entity> entities;
  final ValueChanged<Relationship> onUpdate;

  const RelationshipComponent({
    super.key,
    required this.relationship,
    required this.entities,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final startEntity = entities.firstWhere(
      (entity) => entity.id == relationship.entityId1,
      orElse: () => Entity(id: '', name: 'Unknown', attributes: [], position:  Point(0, 0)),
    );

    final endEntity = entities.firstWhere(
      (entity) => entity.id == relationship.entityId2,
      orElse: () => Entity(id: '', name: 'Unknown', attributes: [], position:  Point(0, 0)),
    );

    return CustomPaint(
      painter: _RelationshipPainter(
        start: startEntity.position,
        end: endEntity.position,
        relationshipType: relationship.type as String,
      ),
    );
  }
}

class _RelationshipPainter extends CustomPainter {
  final Point start;
  final Point end;
  final String relationshipType;

  _RelationshipPainter({
    required this.start,
    required this.end,
    required this.relationshipType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw the line between the start and end points
    canvas.drawLine(
      Offset(start.x.toDouble(), start.y.toDouble()),
      Offset(end.x.toDouble(), end.y.toDouble()),
      paint,
    );

    // Draw the relationship type label
    final textPainter = TextPainter(
      text: TextSpan(
        text: relationshipType,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final midPoint = Offset(
      (start.x + end.x) / 2,
      (start.y + end.y) / 2,
    );
    textPainter.paint(canvas, midPoint.translate(-textPainter.width / 2, -textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}