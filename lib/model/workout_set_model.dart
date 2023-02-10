import 'package:gym_assistant/model/workout_model.dart';

class WorkoutSetModel {
  String name;
  List<WorkoutModel> workoutList;
  int restTime;
  String restTimeType;
  bool isChecked = false;

  WorkoutSetModel(
      {required this.name,
      required this.workoutList,
      required this.restTime,
      required this.restTimeType});
}
