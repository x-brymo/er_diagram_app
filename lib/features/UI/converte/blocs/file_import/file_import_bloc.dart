import 'package:bloc/bloc.dart';
import 'file_import_event.dart';
import 'file_import_state.dart';

class FileImportBloc extends Bloc<FileImportEvent, FileImportState> {
  FileImportBloc() : super(FileImportInitial()) {
    on<ImportFile>((event, emit) async {
      emit(FileImportLoading());
      try {
        // Simulate file import logic
        await Future.delayed(const Duration(seconds: 2));
        // Example: Add the file to import history
        final fileName = event.file.name;
        emit(FileImportSuccess(fileName: fileName));
      } catch (e) {
        emit(FileImportError(message: 'Failed to import file: $e'));
      }
    });

    on<GetImportHistory>((event, emit) async {
      try {
        // Simulate fetching import history
        await Future.delayed(const Duration(seconds: 1));
        final history = [
          {'filename': 'example.drawio', 'timestamp': DateTime.now().millisecondsSinceEpoch},
          {'filename': 'schema.json', 'timestamp': DateTime.now().millisecondsSinceEpoch},
        ];
        emit(FileImportHistoryLoaded(history: history));
      } catch (e) {
        emit(FileImportError(message: 'Failed to load import history: $e'));
      }
    });
  }

  Future<List<Map<String, dynamic>>> getImportHistory() async {
    // Simulate fetching import history
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'filename': 'example.drawio', 'timestamp': DateTime.now().millisecondsSinceEpoch},
      {'filename': 'schema.json', 'timestamp': DateTime.now().millisecondsSinceEpoch},
    ];
  }
}