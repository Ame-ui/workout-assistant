import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_assistant/model/workout_model.dart';
import 'package:gym_assistant/model/workout_set_model.dart';
import 'package:gym_assistant/provider/workout_set_provider.dart';
import 'package:gym_assistant/themes/theme.dart';
import 'package:provider/provider.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key, required this.selectedSet});
  final WorkoutSetModel selectedSet;
  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  // List<String> workoutNameList = [];
  // List<String> workoutCountList = [];
  final TextEditingController _controllerWorkoutName = TextEditingController();
  final TextEditingController _controllerRep = TextEditingController();
  final TextEditingController _controllerSetName = TextEditingController();
  final TextEditingController _controllerRestTime = TextEditingController();
  ValueNotifier<String> restTimeType = ValueNotifier('second');
  ValueNotifier<List<WorkoutModel>> workoutListNotifier = ValueNotifier([]);
  @override
  void initState() {
    // Provider.of<WorkoutProvider>(context, listen: false).workoutList =
    //     widget.selectedSet.workoutList;
    if (widget.selectedSet.name.isNotEmpty) {
      _controllerSetName.text = widget.selectedSet.name;
      _controllerRestTime.text = widget.selectedSet.restTime.toString();
      restTimeType.value = widget.selectedSet.restTimeType;
      workoutListNotifier.value = widget.selectedSet.workoutList;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controllerWorkoutName.dispose();
    _controllerRep.dispose();
    _controllerSetName.dispose();
    _controllerRestTime.dispose();
    restTimeType.dispose();
    workoutListNotifier.dispose();
    super.dispose();
  }

  void addWorkoutToList(WorkoutModel workoutModel) {
    workoutListNotifier.value = List.from(workoutListNotifier.value)..add(workoutModel);
  }

  void insertWorkoutToList(WorkoutModel workoutModel, int index) {
    workoutListNotifier.value = List.from(workoutListNotifier.value)..insert(index, workoutModel);
  }

  void removeWorkoutFromList(int index) {
    workoutListNotifier.value = List.from(workoutListNotifier.value)..removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: myFloatingBtn(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: myAppBar(),
        body: workoutListView());
  }

  InkWell myFloatingBtn() {
    //var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    return InkWell(
      onTap: (() => showDialog(
          context: context,
          /* adding new workout */
          builder: ((context) => AlertDialog(
                title: const Text('Adding workout'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                    autofocus: true,
                    controller: _controllerWorkoutName,
                    decoration: const InputDecoration(hintText: 'Workout Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controllerRep,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Reps'),
                  )
                ]),
                actions: [
                  TextButton(
                      onPressed: (() {
                        Navigator.of(context).pop();
                      }),
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: (() {
                        if (_controllerWorkoutName.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Workout name can\'t be empty!',
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                        } else if (_controllerRep.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Rep can\'t be empty!',
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                        } else {
                          addWorkoutToList(WorkoutModel(
                              name: _controllerWorkoutName.text, rep: _controllerRep.text));
                          _controllerWorkoutName.clear();
                          _controllerRep.clear();
                          Navigator.of(context).pop();
                        }
                      }),
                      child: const Text('Add'))
                ],
              )))),
      child: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
              color: MyTheme.primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              )),
          child: Text(
            'Add workout',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          )),
    );
  }

  AppBar myAppBar() {
    // var workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    var workoutSetProvider = Provider.of<WorkoutSetProvider>(context, listen: false);
    List<String> dropDownItems = ['second', 'minute'];

    return AppBar(
      backgroundColor: MyTheme.primaryColor,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      title: Text(
        widget.selectedSet.name.isEmpty ? 'Create new set' : widget.selectedSet.name,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      actions: [
        Center(
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: ((context) => AlertDialog(
                        title: widget.selectedSet.name.isEmpty
                            ? const Text('Saving new set')
                            : const Text('Update the set'),
                        content: Column(mainAxisSize: MainAxisSize.min, children: [
                          TextField(
                            autofocus: true,
                            controller: _controllerSetName,
                            decoration: const InputDecoration(hintText: 'Set name'),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: TextField(
                                controller: _controllerRestTime,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(hintText: 'Resting time'),
                              )),
                              const SizedBox(width: 10),
                              ValueListenableBuilder(
                                  valueListenable: restTimeType,
                                  builder: (context, timeType, child) => DropdownButton(
                                      hint: Text(restTimeType.value),
                                      items: dropDownItems
                                          .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                      onChanged: (value) => restTimeType.value = value as String))
                            ],
                          )
                        ]),
                        actions: [
                          TextButton(
                              onPressed: (() {
                                Navigator.of(context).pop();
                              }),
                              child: const Text('Cancel')),
                          ElevatedButton(
                              onPressed: (() {
                                if (_controllerSetName.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'Set name can\'t be empty!',
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white);
                                } else if (_controllerRestTime.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'Rest time can\'t be empty!',
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white);
                                } else {
                                  /* create new file */

                                  final tempSet = WorkoutSetModel(
                                      name: _controllerSetName.text,
                                      workoutList: workoutListNotifier.value,
                                      restTime: int.parse(_controllerRestTime.text),
                                      restTimeType: restTimeType.value);

                                  if (widget.selectedSet.name.isEmpty) {
                                    /* it means create */
                                    workoutSetProvider.addSetToList(tempSet);
                                  } else {
                                    /* it means update */
                                    workoutSetProvider.updateSetInList(
                                        workoutSetProvider.setList[
                                            workoutSetProvider.setList.indexOf(widget.selectedSet)],
                                        tempSet);
                                  }
                                  _controllerSetName.clear();
                                  _controllerRestTime.clear();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                              }),
                              child: const Text('Save'))
                        ],
                      )));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Text(
                'Done',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: MyTheme.primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        )
      ],
    );
  }

  ValueListenableBuilder workoutListView() {
    return ValueListenableBuilder(
      valueListenable: workoutListNotifier,
      builder: (BuildContext context, workoutList, Widget? child) {
        if (workoutList.isEmpty) {
          return const Center(
            child: Text(
              'Workout list is empty\n\nPress    \'\'Add Workout\'\'   to add',
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ReorderableListView.builder(
              itemCount: workoutList.length,
              onReorder: ((oldIndex, newIndex) {
                if (oldIndex < newIndex) newIndex--;
                final workout = workoutList[oldIndex];
                removeWorkoutFromList(
                  oldIndex,
                );
                insertWorkoutToList(workout, newIndex);
              }),
              itemBuilder: ((context, index) {
                int rep = int.parse(workoutList[index].rep);
                return Container(
                  key: ValueKey(index.toString()),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                        )
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.drag_handle),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workoutList[index].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                workoutList[index].rep + (rep > 1 ? ' reps' : ' rep'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: (() {
                                insertWorkoutToList(
                                  WorkoutModel(
                                      name: workoutList[index].name, rep: workoutList[index].rep),
                                  index + 1,
                                );
                              }),
                              icon: const Icon(
                                Icons.control_point_duplicate,
                              )),
                          IconButton(
                              onPressed: (() {
                                removeWorkoutFromList(index);
                              }),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              )),
                        ],
                      )
                    ],
                  ),
                );
              }),
            ),
          );
        }
      },
    );
  }
}
