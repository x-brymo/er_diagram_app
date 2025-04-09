// bloc_observer.dart
import 'package:flutter_bloc/flutter_bloc.dart';


class AppBlocObserver extends BlocObserver  {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // You can log the state changes here if needed
     print('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Handle errors here if needed
    print('${bloc.runtimeType} $error');
  }
}

// not found all this :
// ConverterBloc
// ConvertDiagram
// ---------------
// FileImportBloc
// FileImportBloc
// --------------
// HomeBloc
// --------------
// RelationshipComponent
// ------------------
// theme.dart