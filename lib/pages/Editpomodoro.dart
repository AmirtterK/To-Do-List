import 'package:to_do_list/models/widgets/Appbar.dart';
import 'package:to_do_list/pages/Pomodoro.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class Editpomodoro extends StatefulWidget {
  const Editpomodoro({super.key});

  @override
  State<Editpomodoro> createState() => _EditpomodoroState();
}

class _EditpomodoroState extends State<Editpomodoro> {
  final String _Pagetitle = "Editpomodoro";
  @override
  void dispose() async {
    super.dispose();

    await UpdatePomodoro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      extendBodyBehindAppBar: true,
      appBar: Device.desktopPlatform
          ? null
          : Appbar(
              title: _Pagetitle,
            ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context)
                  .colorScheme
                  .secondaryFixed
                  .withValues(alpha: 0.5),
              Theme.of(context).colorScheme.secondaryFixed
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: (Device.screenHeight / 8).round() * 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Device.pixelRatio * 2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        await editPomodoroTime(context, setState, index,
                            PomodoroData.endTimer[index * 2]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14)),
                        alignment: Alignment.center,
                        width: (Device.screenWidth / 3.65).round() * 1,
                        height: (Device.screenWidth / 3.65).round() * 1,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Device.pixelRatio * 4,
                            ),
                            Text(
                              PomodoroData.endTimer[index * 2].toString(),
                              style: TextStyle(
                                  fontSize: Device.pixelRatio * 13,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: Device.menuFont),
                            ),
                            Text(
                              PomodoroData.timerName[index].toString(),
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: Device.pixelRatio * 5,
                                  fontWeight: Device.menuFont),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Device.pixelRatio * 2,
                    vertical: Device.pixelRatio * 4,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      await editPomodoroSets(
                          context, setState, true, PomodoroData.sets);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      width: (Device.screenWidth / 2.5).round() * 1,
                      height: (Device.screenWidth / 3).round() * 1,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Device.pixelRatio * 4,
                          ),
                          Text(
                            PomodoroData.sets.toString(),
                            style: TextStyle(
                                fontSize: Device.pixelRatio * 13,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: Device.menuFont),
                          ),
                          Text(
                            "POMODOROS",
                            style: TextStyle(
                                fontSize: Device.pixelRatio * 4,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: Device.menuFont),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Device.pixelRatio * 2,
                      vertical: Device.pixelRatio * 2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      await editPomodoroSets(
                          context, setState, false, PomodoroData.breakSet);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14)),
                      alignment: Alignment.center,
                      width: (Device.screenWidth / 2.5).round() * 1,
                      height: (Device.screenWidth / 3).round() * 1,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Device.pixelRatio * 4,
                          ),
                          Text(
                            PomodoroData.breakSet.toString(),
                            style: TextStyle(
                                fontSize: Device.pixelRatio * 13,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: Device.menuFont),
                          ),
                          Text(
                            "POMODOROS UNTIL\nLONG BREAK",
                            style: TextStyle(
                                fontSize: Device.pixelRatio * 4,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: Device.menuFont),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<void> editPomodoroTime(
    BuildContext context, Function updateUI, int index, int time) async {
  showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    anchorPoint: Offset.zero,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 0.2), end: Offset(0, -0.1))
            .animate(animation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(animation),
          child: Padding(
            padding: EdgeInsets.only(
                left: Device.desktopPlatform ? Device.getRailWidth() : 0),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(
                  horizontal: (Device.screenWidth / 6).round() * 1),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: StatefulBuilder(
                builder: (context, DialogsetState) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  constraints: BoxConstraints(maxWidth: 300, maxHeight: 220),
                  height: (Device.screenHeight / 3).round() * 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: time != 1
                                ? () async {
                                    DialogsetState(
                                      () {
                                        time--;
                                      },
                                    );
                                  }
                                : null,
                            icon: Icon(
                              Icons.remove_rounded,
                              size: Device.pixelRatio * 12,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          NumberPicker(
                            selectedTextStyle: TextStyle(
                              fontSize: Device.pixelRatio * 11,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            textStyle: TextStyle(
                              fontSize: Device.pixelRatio * 6,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            itemCount: 3,
                            itemHeight: Device.pixelRatio * 18,
                            step: 1,
                            minValue: 1,
                            maxValue: 60,
                            value: time,
                            onChanged: (value) async {
                              DialogsetState(
                                () {
                                  time = value;
                                },
                              );
                            },
                          ),
                          IconButton(
                            onPressed: time != 60
                                ? () async {
                                    DialogsetState(() {
                                      time++;
                                    });
                                  }
                                : null,
                            icon: Icon(
                              Icons.add_rounded,
                              size: Device.pixelRatio * 12,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          updateUI(
                            () {
                              PomodoroData.endTimer[index * 2] = time;
                            },
                          );
                          await resetTimer();
                        },
                        icon: Icon(
                          Icons.check_rounded,
                          size: Device.pixelRatio * 12,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> editPomodoroSets(
    BuildContext context, Function updateUI, bool setsGoal, int sets) async {
  showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    anchorPoint: Offset.zero,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 0.2), end: Offset(0, -0.1))
            .animate(animation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(animation),
          child: Padding(
            padding: EdgeInsets.only(
                left: Device.desktopPlatform ? Device.getRailWidth() : 0),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(
                  horizontal: (Device.screenWidth / 6).round() * 1),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: StatefulBuilder(
                builder: (context, DialogsetState) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  constraints: BoxConstraints(maxWidth: 300, maxHeight: 200),
                  height: (Device.screenHeight / 3).round() * 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: sets != 1
                                ? () async {
                                    DialogsetState(
                                      () {
                                        sets--;
                                      },
                                    );
                                  }
                                : null,
                            icon: Icon(
                              Icons.remove_rounded,
                              size: Device.pixelRatio * 12,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          NumberPicker(
                            selectedTextStyle: TextStyle(
                              fontSize: Device.pixelRatio * 11,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            textStyle: TextStyle(
                              fontSize: Device.pixelRatio * 6,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            itemCount: 3,
                            itemHeight: Device.pixelRatio * 18,
                            step: 1,
                            minValue: 1,
                            maxValue: 60,
                            value: sets,
                            onChanged: (value) async {
                              DialogsetState(
                                () {
                                  sets = value;
                                },
                              );
                            },
                          ),
                          IconButton(
                            onPressed: sets != 100
                                ? () async {
                                    DialogsetState(() {
                                      sets++;
                                    });
                                  }
                                : null,
                            icon: Icon(
                              Icons.add_rounded,
                              size: Device.pixelRatio * 12,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          updateUI(
                            () {
                              setsGoal
                                  ? PomodoroData.sets = sets
                                  : PomodoroData.breakSet = sets;
                            },
                          );
                          await resetTimer();
                        },
                        icon: Icon(
                          Icons.check_rounded,
                          size: Device.pixelRatio * 12,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
