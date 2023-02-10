import 'package:flutter/cupertino.dart';
import 'package:gym_assistant/model/workout_set_model.dart';

class WorkoutSetProvider extends ChangeNotifier {
  List<WorkoutSetModel> _setList = [];

  List<WorkoutSetModel> get setList => _setList;

  void addSetToList(WorkoutSetModel workoutSetModel) {
    _setList.add(workoutSetModel);
    notifyListeners();
  }

  void updateSetInList(WorkoutSetModel oldSet, WorkoutSetModel newSet) {
    _setList[_setList.indexOf(oldSet)] = newSet;
    notifyListeners();
  }

  void deleteSetFromList() {
    _setList.removeWhere((element) => element.isChecked == true);
    notifyListeners();
  }

  void checkSetWithIdex(int index, bool value) {
    _setList[index].isChecked = value;
    notifyListeners();
  }

  void checkAllSets() {
    for (var set in setList) {
      set.isChecked = true;
    }
    notifyListeners();
  }

  void uncheckAllSets() {
    for (var set in setList) {
      set.isChecked = false;
    }
    notifyListeners();
  }

  WorkoutSetModel selectedSet(WorkoutSetModel workoutSetModel) => workoutSetModel;
}
