// Project Structure
/*
er_diagram_app/
├── lib/
│   ├── app/
│   │   ├── app.dart
│   │   ├── bloc_observer.dart
│   │   └── theme.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── services/
│   │   │   ├── storage_service.dart
│   │   │   ├── permission_service.dart
│   │   │   └── file_service.dart
│   │   └── utils/
│   │       ├── responsive_utils.dart
│   │       └── export_utils.dart
│   ├── features/
│   │   ├── splash/
│   │   │   ├── view/
│   │   │   │   └── splash_view.dart
│   │   │   └── bloc/
│   │   │       ├── splash_bloc.dart
│   │   │       ├── splash_event.dart
│   │   │       └── splash_state.dart
│   │   ├── home/
│   │   │   ├── view/
│   │   │   │   └── home_view.dart
│   │   │   └── bloc/
│   │   │       ├── home_bloc.dart
│   │   │       ├── home_event.dart
│   │   │       └── home_state.dart
│   │   ├── er_designer/
│   │   │   ├── view/
│   │   │   │   └── er_designer_view.dart
│   │   │   ├── components/
│   │   │   │   ├── entity_component.dart
│   │   │   │   └── relationship_component.dart
│   │   │   └── bloc/
│   │   │       ├── er_designer_bloc.dart
│   │   │       ├── er_designer_event.dart
│   │   │       └── er_designer_state.dart
│   │   ├── converter/
│   │   │   ├── view/
│   │   │   │   └── converter_view.dart
│   │   │   ├── models/
│   │   │   │   ├── er_model.dart
│   │   │   │   └── conversion_result.dart
│   │   │   └── bloc/
│   │   │       ├── converter_bloc.dart
│   │   │       ├── converter_event.dart
│   │   │       └── converter_state.dart
│   │   └── file_import/
│   │       ├── view/
│   │       │   └── file_import_view.dart
│   │       └── bloc/
│   │           ├── file_import_bloc.dart
│   │           ├── file_import_event.dart
│   │           └── file_import_state.dart
│   ├── data/
│   │   ├── repositories/
│   │   │   ├── diagram_repository.dart
│   │   │   └── conversion_repository.dart
│   │   ├── models/
│   │   │   ├── entity.dart
│   │   │   ├── relationship.dart
│   │   │   └── database_schema.dart
│   │   └── datasources/
│   │       ├── local_datasource.dart
│   │       └── file_datasource.dart
│   └── main.dart
└── pubspec.yaml
*/

























// // converter_view.dart (simplified)
// import 'package:flutter/material.dart';
// import 'package:flutter_syntax_view/flutter_syntax_view.dart';
// import 'package:er_diagram_app/features/converter/bloc/converter_bloc.dart';
// import 'package:er_diagram_app/features/converter/bloc/converter_event.