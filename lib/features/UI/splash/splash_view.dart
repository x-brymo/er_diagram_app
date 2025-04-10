// splash_view.dart
import 'package:er_diagram_app/features/UI/blocs/splash/splash_bloc.dart';
import 'package:er_diagram_app/features/UI/blocs/splash/splash_event.dart';
import 'package:er_diagram_app/features/UI/blocs/splash/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(InitializeApp()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is AppInitialized) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeView()),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   'assets/images/logo.png',
                //   width: 200,
                //   height: 200,
                // ),
                Icon(Icons.design_services, size: 100, color: Theme.of(context).primaryColor),
                const SizedBox(height: 30),
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                const Text(
                  'ER Diagram Designer',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}