// main.dart
import 'package:er_diagram_app/app.dart';
import 'package:er_diagram_app/core/config/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  runApp(const ERDiagramApp());
}