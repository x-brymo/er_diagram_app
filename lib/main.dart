// main.dart
import 'package:er_diagram_app/app.dart';
import 'package:er_diagram_app/core/config/bloc_observer.dart';
import 'package:er_diagram_app/core/config/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
   PermissionService();
  runApp(const ERDiagramApp());
}