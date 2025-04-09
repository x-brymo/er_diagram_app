import 'package:equatable/equatable.dart';

abstract class ConverterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConvertDiagram extends ConverterEvent {
  final int diagramId;
  final String conversionType;

  ConvertDiagram({required this.diagramId, required this.conversionType});

  @override
  List<Object?> get props => [diagramId, conversionType];
}