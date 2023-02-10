import 'package:flutter/material.dart';
import 'package:gym_assistant/model/workout_set_model.dart';
import 'package:gym_assistant/provider/workout_set_provider.dart';
import 'package:gym_assistant/route/route_name.dart';
import 'package:gym_assistant/themes/theme.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ValueNotifier<bool> isSelectMode = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: isSelectMode,
        builder: (BuildContext context, bool value, Widget? child) {
          return value ? const SizedBox.shrink() : addFloatingActionBtn();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: drawerPage(),
      appBar: homeAppbar(),
      body: setListView(),
    );
  }

  FloatingActionButton addFloatingActionBtn() {
    return FloatingActionButton(
        backgroundColor: MyTheme.primaryColor,
        onPressed: (() => Navigator.of(context).pushNamed(RoutesName.addWorkout,
            arguments: WorkoutSetModel(name: '', workoutList: [], restTime: 0, restTimeType: ''))),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ));
  }

  Container drawerPage() {
    return Container(
      color: MyTheme.primaryColor,
      child: SafeArea(
        child: Drawer(
          backgroundColor: const Color(0xfff4f5f8),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(10),
              color: const Color(0xff314b55),
              child: Center(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                        width: 100, child: Image(image: AssetImage('assets/app_logo.png'))),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Workout\nAssistant',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.white60, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  AppBar homeAppbar() {
    return AppBar(
      backgroundColor: MyTheme.primaryColor,
      title: Text('Workout Assiatant',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
      leading: IconButton(
          onPressed: (() {
            _scaffoldKey.currentState!.openDrawer();
          }),
          icon: const Icon(Icons.menu)),
    );
  }

  Consumer setListView() {
    return Consumer<WorkoutSetProvider>(builder: (context, provider, child) {
      // Fluttertoast.showToast(msg: 'rebuild');
      return provider.setList.isEmpty
          ? const Center(
              child: Text(
                'There is no set\n\nPress + to add more',
                textAlign: TextAlign.center,
                textHeightBehavior: TextHeightBehavior(),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.setList.length,
                    itemBuilder: ((context, index) => Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: provider.setList[index].isChecked
                                        ? Colors.blue.shade100
                                        : Colors.white,
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 2,
                                          // spreadRadius: 2,
                                          offset: Offset(1, 1))
                                    ]),
                                child: ListTile(
                                    onLongPress: () {
                                      isSelectMode.value = true;
                                      provider.checkSetWithIdex(index, true);
                                    },
                                    onTap: (isSelectMode.value
                                        ? () => provider.checkSetWithIdex(
                                            index, !provider.setList[index].isChecked)
                                        : () => Navigator.of(context).pushNamed(
                                            RoutesName.selectedSet,
                                            arguments: provider.setList[index])),
                                    title: Text(
                                      provider.setList[index].name,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    subtitle: Text(
                                        'Resting time: ${provider.setList[index].restTime}${provider.setList[index].restTimeType}'),
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          provider.setList[index].workoutList.length.toString(),
                                          style: Theme.of(context).textTheme.headlineSmall,
                                        ),
                                        Text(provider.setList[index].workoutList.length > 1
                                            ? 'Sets'
                                            : 'Set')
                                      ],
                                    )),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: isSelectMode,
                              builder: (BuildContext context, bool value, Widget? child) {
                                return value
                                    ? Checkbox(
                                        value: provider.setList[index].isChecked,
                                        onChanged: (value) {
                                          provider.checkSetWithIdex(index, value as bool);
                                        })
                                    : const SizedBox.shrink();
                              },
                            ),
                          ],
                        )),
                  ),
                ),
                /* for bottm container for select and delete */
                ValueListenableBuilder(
                  valueListenable: isSelectMode,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return value
                        ? Container(
                            height: 75,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    isSelectMode.value = false;
                                    provider.uncheckAllSets();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Cancel',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    provider.checkAllSets();
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.library_add_check,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Select All',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    provider.deleteSetFromList();
                                    isSelectMode.value = false;
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Delete',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            );
    });
  }
}
