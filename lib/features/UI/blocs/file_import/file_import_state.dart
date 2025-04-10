import 'package:equatable/equatable.dart';

abstract class FileImportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FileImportInitial extends FileImportState {}

class FileImportLoading extends FileImportState {}

class FileImportSuccess extends FileImportState {
  final String fileName;

  FileImportSuccess({required this.fileName});

  @override
  List<Object?> get props => [fileName];
}

class FileImportError extends FileImportState {
  final String message;

  FileImportError({required this.message});

  @override
  List<Object?> get props => [message];
}

class FileImportHistoryLoaded extends FileImportState {
  final List<Map<String, dynamic>> history;

  FileImportHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}