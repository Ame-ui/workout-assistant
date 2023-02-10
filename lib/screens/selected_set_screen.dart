import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_assistant/model/workout_set_model.dart';
import 'package:gym_assistant/route/route_name.dart';
import 'package:gym_assistant/themes/theme.dart';
import 'package:provider/provider.dart';
import '../provider/workout_set_provider.dart';

class SelectedSetScreen extends StatefulWidget {
  const SelectedSetScreen({super.key, required this.selectedSet});
  final WorkoutSetModel selectedSet;

  @override
  State<SelectedSetScreen> createState() => _SelectedSetScreenState();
}

class _SelectedSetScreenState extends State<SelectedSetScreen> with TickerProviderStateMixin {
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex =
        Provider.of<WorkoutSetProvider>(context, listen: false).setList.indexOf(widget.selectedSet);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedAppbar(),
      body: workoutList(),
    );
  }

  Consumer workoutList() {
    return Consumer<WorkoutSetProvider>(builder: (context, provider, child) {
      // Fluttertoast.showToast(msg: 'consumer');
      var selectedSet = provider.setList[selectedIndex];
      if (widget.selectedSet.workoutList.isEmpty) {
        return const Center(
          child: Text('workout list is empty add some'),
        );
      } else {
        return Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedSet.workoutList.length,
              itemBuilder: ((context, index) {
                int rep = int.parse(selectedSet.workoutList[index].rep);
                return Container(
                  key: ValueKey(index.toString()),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedSet.workoutList[index].name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            selectedSet.workoutList[index].rep + (rep > 1 ? ' reps' : ' rep'),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RoutesName.doWorkout, arguments: selectedSet);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20, top: 10),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: const BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  'Start Working out',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ))
        ]);
      }
    });
  }

  AppBar selectedAppbar() {
    // var workoutSetProvider = Provider.of<WorkoutSetProvider>(context, listen: false);
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      title: Consumer<WorkoutSetProvider>(builder: (context, provider, child) {
        var selectedSet = provider.setList[selectedIndex];
        return Text(
          selectedSet.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
        );
      }),
      actions: [
        Center(
          child: InkWell(
            onTap: () => Navigator.of(context)
                .pushNamed(RoutesName.addWorkout, arguments: widget.selectedSet),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Text(
                'Edit',
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
}
