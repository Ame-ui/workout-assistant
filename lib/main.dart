import 'package:flutter/material.dart';
import 'package:gym_assistant/provider/workout_set_provider.dart';
import 'package:gym_assistant/route/route.dart';
import 'package:gym_assistant/themes/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WorkoutSetProvider>(create: ((context) => WorkoutSetProvider())),
      ],
      child: MaterialApp(
        title: 'Workout Assistant',
        theme: MyTheme.normalTheme,
        onGenerateRoute: Routes.generate,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
