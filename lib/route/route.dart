import 'package:flutter/material.dart';
import 'package:gym_assistant/model/workout_set_model.dart';
import 'package:gym_assistant/screens/add_workout_screen.dart';
import 'package:gym_assistant/route/route_name.dart';
import 'package:gym_assistant/screens/do_workout_screen.dart';
import 'package:gym_assistant/screens/selected_set_screen.dart';
import 'package:gym_assistant/screens/splash_screen.dart';
import '../screens/home_screen.dart';

class Routes {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case RoutesName.home:
        return MaterialPageRoute(
          builder: (context) => const Home(),
        );
      case RoutesName.addWorkout:
        return MaterialPageRoute(
          builder: (context) =>
              AddWorkoutScreen(selectedSet: settings.arguments as WorkoutSetModel),
        );
      case RoutesName.selectedSet:
        return MaterialPageRoute(
          builder: (context) =>
              SelectedSetScreen(selectedSet: settings.arguments as WorkoutSetModel),
        );
      case RoutesName.doWorkout:
        return MaterialPageRoute(
          builder: (context) => DoWorkoutScreen(selectedSet: settings.arguments as WorkoutSetModel),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Error(),
        );
    }
  }
}

class Error extends StatelessWidget {
  const Error({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Erroe'),
      ),
    );
  }
}
