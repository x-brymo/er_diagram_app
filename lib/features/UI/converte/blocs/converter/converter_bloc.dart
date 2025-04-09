import 'package:bloc/bloc.dart';
import 'converter_event.dart';
import 'converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  ConverterBloc() : super(ConverterInitial()) {
    on<ConvertDiagram>((event, emit) async {
      emit(ConversionLoading());
      try {
        // Simulate conversion logic
        await Future.delayed(const Duration(seconds: 2));
        final output = 'Converted data for diagram ID: ${event.diagramId}';
        emit(ConversionComplete(output: output));
      } catch (e) {
        emit(ConversionError(message: 'Failed to convert diagram: $e'));
      }
    });
  }

  Future<List<Map<String, dynamic>>> getAllDiagrams() async {
    // Simulate fetching diagrams
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'id': 1, 'name': 'Diagram 1', 'updated_at': DateTime.now().millisecondsSinceEpoch},
      {'id': 2, 'name': 'Diagram 2', 'updated_at': DateTime.now().millisecondsSinceEpoch},
    ];
  }
}