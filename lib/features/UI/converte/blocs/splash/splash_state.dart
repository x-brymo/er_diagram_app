// splash_state.dart
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class AppInitialized extends SplashState {}

class SplashError extends SplashState {
  final String message;
  
  SplashError(this.message);
}