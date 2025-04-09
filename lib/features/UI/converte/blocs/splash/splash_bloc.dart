// splash_bloc.dart
import 'package:er_diagram_app/core/config/permission_service.dart';

import '../../../../data/service/storage_service.dart';
import 'splash_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<InitializeApp>(_onInitializeApp);
  }
  
  void _onInitializeApp(InitializeApp event, Emitter<SplashState> emit) async {
    emit(SplashLoading());
    
    try {
      // Simulate loading time
      await Future.delayed(const Duration(seconds: 2));
      
      // Initialize services
      // In a real app, you would inject these services
      final permissionService = PermissionService();
      final storageService = StorageService();
      
      // Request necessary permissions
      await permissionService.requestStoragePermission();
      
      // Initialize storage
      await storageService.initialize();
      
      emit(AppInitialized());
    } catch (e) {
      emit(SplashError(e.toString()));
    }
  }
}