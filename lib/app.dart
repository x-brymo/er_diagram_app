// app.dart
import 'package:er_diagram_app/core/config/permission_service.dart';
import 'package:er_diagram_app/features/UI/converte/blocs/converter/converter_bloc.dart';
import 'package:er_diagram_app/features/UI/converte/blocs/er_designer/er_designer_bloc.dart';
import 'package:er_diagram_app/features/UI/converte/blocs/file_import/file_import_bloc.dart';
import 'package:er_diagram_app/features/UI/converte/blocs/home/home_bloc.dart';
import 'package:er_diagram_app/features/UI/converte/blocs/splash/splash_bloc.dart';
import 'package:er_diagram_app/features/UI/splash/splash_view.dart';
import 'package:er_diagram_app/features/data/service/file_service.dart';
import 'package:er_diagram_app/features/data/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/theme.dart';
// import 'package:er_diagram_app/features/splash/view/splash_view.dart';
// import 'package:er_diagram_app/core/services/storage_service.dart';
// import 'package:er_diagram_app/core/services/permission_service.dart';
// import 'package:er_diagram_app/core/services/file_service.dart';
// import 'package:er_diagram_app/app/theme.dart';

class ERDiagramApp extends StatelessWidget {
  const ERDiagramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StorageService>(
          create: (context) => StorageService(),
        ),
        RepositoryProvider<PermissionService>(
          create: (context) => PermissionService(),
        ),
        RepositoryProvider<FileService>(
          create: (context) => FileService(),
        ),
       BlocProvider<HomeBloc>(create:
       (context)=>HomeBloc()
        
        ),
       BlocProvider<ConverterBloc>(create:
       (context)=>ConverterBloc()
        
        ),
       BlocProvider<SplashBloc>(create:
       (context)=>SplashBloc()
        
        ),
       BlocProvider<ERDesignerBloc>(create:
       (context)=>ERDesignerBloc()
        
        ),
       BlocProvider<FileImportBloc>(create:
       (context)=>FileImportBloc()
        
        ),
      ],
      child: MaterialApp(
        title: 'ER Diagram Designer',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashView(),
      ),
    );
  }
}