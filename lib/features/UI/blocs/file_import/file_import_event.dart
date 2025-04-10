import 'package:equatable/equatable.dart';

abstract class FileImportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImportFile extends FileImportEvent {
  final dynamic file;

  ImportFile(this.file);

  @override
  List<Object?> get props => [file];
}

class GetImportHistory extends FileImportEvent {}