import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_assistant/model/workout_set_model.dart';

import '../themes/theme.dart';

class DoWorkoutScreen extends StatefulWidget {
  const DoWorkoutScreen({super.key, required this.selectedSet});
  final WorkoutSetModel selectedSet;
  @override
  State<DoWorkoutScreen> createState() => _DoWorkoutScreenState();
}

class _DoWorkoutScreenState extends State<DoWorkoutScreen> with TickerProviderStateMixin {
  PageController _pageController = PageController();
  ValueNotifier<int> currentPageNotifier = ValueNotifier(0);
  ValueNotifier<List<bool>> isFinishNotifier = ValueNotifier([]);
  ValueNotifier<int> restTime = ValueNotifier(0);
  @override
  void initState() {
    for (int i = 0; i < widget.selectedSet.workoutList.length; i++) {
      isFinishNotifier.value.add(false);
    }
    restTime.value = widget.selectedSet.restTime;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: workoutProcessContent(),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      title: Text(
        widget.selectedSet.name,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      elevation: 0,
    );
  }

  Column workoutProcessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /* for workout process */
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            color: MyTheme.primaryColor,
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: PageView.builder(
                    onPageChanged: (value) {
                      currentPageNotifier.value = value;
                    },
                    allowImplicitScrolling: false,
                    controller: _pageController,
                    itemCount: widget.selectedSet.workoutList.length,
                    itemBuilder: (context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.selectedSet.workoutList[index].name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: Colors.white.withOpacity(0.9)),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.selectedSet.workoutList[index].rep,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: Colors.white, fontSize: 80),
                          )
                        ],
                      );
                    }),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        if (currentPageNotifier.value > 0) {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 300), curve: Curves.linear);
                          currentPageNotifier.value--;
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          ),
                          Text(
                            'Back',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          )
                        ],
                      )),
                  /* finish button */
                  ValueListenableBuilder(
                    valueListenable: currentPageNotifier,
                    builder: (BuildContext context, int currentIndex, Widget? child) {
                      return GestureDetector(
                          onTap: () {
                            if (currentPageNotifier.value < widget.selectedSet.workoutList.length &&
                                !isFinishNotifier.value[currentIndex]) {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.linear);
                              isFinishNotifier.value[currentIndex] = true;
                              isFinishNotifier.value = List.from(isFinishNotifier.value);
                              Fluttertoast.showToast(
                                  msg: isFinishNotifier.value[currentIndex].toString());
                              print(isFinishNotifier.value);

                              showRestingTimeDialog();
                              currentPageNotifier.value++;
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20, top: 10),
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              currentIndex == widget.selectedSet.workoutList.length
                                  ? 'Finish'
                                  : 'Done',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: MyTheme.primaryColor, fontWeight: FontWeight.w600),
                            ),
                          ));
                    },
                  ),
                  InkWell(
                      onTap: () {
                        if (currentPageNotifier.value < widget.selectedSet.workoutList.length) {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300), curve: Curves.linear);
                          currentPageNotifier.value++;
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            'Skip',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
        /* list of workouts */
        Expanded(
          child: ListView.builder(
            itemCount: widget.selectedSet.workoutList.length,
            itemBuilder: ((context, index) {
              /* to determine rep or reps */
              int rep = int.parse(widget.selectedSet.workoutList[index].rep);
              return ValueListenableBuilder(
                valueListenable: currentPageNotifier,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        border: currentPageNotifier.value == index
                            ? Border.all(color: MyTheme.primaryColor, width: 2)
                            : null,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: isFinishNotifier.value[index]
                            ? MyTheme.primaryColor.withOpacity(0.5)
                            : Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurStyle: BlurStyle.outer,
                            blurRadius: 2,
                          )
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectedSet.workoutList[index].name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: isFinishNotifier.value[index]
                                      ? Colors.black54
                                      : Colors.black),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.selectedSet.workoutList[index].rep +
                                  (rep > 1 ? ' reps' : ' rep'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.black54),
                            ),
                          ],
                        ),
                        /* didn't add visibility cuz background is also white :) */
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        )
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  showRestingTimeDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final totalTime = widget.selectedSet.restTime;
          Timer mTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (restTime.value > 0) {
              restTime.value--;
            } else {
              Timer(const Duration(milliseconds: 500), () {
                restTime.value = widget.selectedSet.restTime;
              });
              timer.cancel();
              Navigator.pop(context);
            }
          });
          return AlertDialog(
            contentPadding: const EdgeInsets.all(20),
            title: const Center(child: Text('Rest')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: restTime,
                  builder: (BuildContext context, int value, Widget? child) {
                    return
                        /* countdown circle */
                        Stack(alignment: const Alignment(0, 0), children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: restTime.value / totalTime,
                          color: Colors.blue,
                        ),
                      ),
                      Text(value.toString())
                    ]);
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Timer(const Duration(milliseconds: 500), () {
                      restTime.value = totalTime;
                    });
                    mTimer.cancel();
                    Navigator.pop(context);
                  },
                  child: const Text('Continue'))
            ],
          );
        });
  }
}
