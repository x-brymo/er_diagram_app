import 'package:equatable/equatable.dart';

abstract class ConverterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConverterInitial extends ConverterState {}

class ConversionLoading extends ConverterState {}

class ConversionComplete extends ConverterState {
  final String output;

  ConversionComplete({required this.output});

  @override
  List<Object?> get props => [output];
}

class ConversionError extends ConverterState {
  final String message;

  ConversionError({required this.message});

  @override
  List<Object?> get props => [message];
}