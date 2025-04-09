import 'package:bloc/bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeFeatures>((event, emit) async {
      emit(HomeLoading());
      try {
        // Simulate loading features (e.g., fetching data or initializing)
        await Future.delayed(const Duration(seconds: 1));
        emit(HomeLoaded(features: _getFeatures()));
      } catch (e) {
        emit(HomeError(message: 'Failed to load features: $e'));
      }
    });
  }

  List<Map<String, String>> _getFeatures() {
    return [
      {'title': 'Design ER Diagram', 'description': 'Create entity relationship diagrams visually'},
      {'title': 'Convert to RS', 'description': 'Convert ER diagram to Relational Schema'},
      {'title': 'Generate SQL', 'description': 'Create SQL from your ER diagram'},
      {'title': 'Generate JSON', 'description': 'Export your schema as JSON'},
      {'title': 'Generate Dart Classes', 'description': 'Create Dart models from your schema'},
      {'title': 'Import Diagram', 'description': 'Import from Draw.io and other formats'},
    ];
  }
}