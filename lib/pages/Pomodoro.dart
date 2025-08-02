import 'dart:async';

import 'package:to_do_list/models/icons/customIcons.dart';
import 'package:to_do_list/models/widgets/Appbar.dart';
import 'package:to_do_list/pages/Editpomodoro.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => PomodoroState();
}

class PomodoroState extends State<Pomodoro> {
  final String _Pagetitle = "Pomodoro";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        PomodoroData.timer = DateTime(
          0,
          0,
          0,
          0,
          PomodoroData.time[PomodoroData.status],
          PomodoroData.time[PomodoroData.status + 1],
        );
        if (PomodoroData.isRunning) {
          PomodoroData.periodicTimer?.cancel();
          await runTimerLocally(setState);
        }
      },
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();

    PomodoroData.timer = DateTime(
      0,
      0,
      0,
      0,
      PomodoroData.time[PomodoroData.status],
      PomodoroData.time[PomodoroData.status + 1],
    );
    if (PomodoroData.isRunning) {
      PomodoroData.periodicTimer?.cancel();
      await runTimerRemotely();
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Device.isEditPomodoroDesktop && Device.desktopPlatform)
        ? Editpomodoro()
        : Scaffold(
            backgroundColor: Colors.white,
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: (Device.screenHeight / 9).round() * 1,
                      right: (Device.screenWidth / 22).round() * 1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 4,
                        ),
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              Device.isEditPomodoroDesktop = true;
                            });
                            if (!Device.desktopPlatform) {
                              await context.pushNamed("Editpomodoro");
                            }
                          },
                          icon: Icon(
                            CustomIcons.editPomodoro,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: (Device.screenHeight / 500).round() * 1,
                      bottom: (Device.screenHeight / 40).round() * 1,
                    ),
                    child: CircularPercentIndicator(
                      lineWidth: 15,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 1000,
                      radius: (Device.screenWidth / 2.5).round() * 1,
                      percent: PomodoroData.progress,
                      progressColor: Theme.of(context)
                          .colorScheme
                          .secondaryFixed
                          .withValues(alpha: 0.8),
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "${PomodoroData.time[PomodoroData.status].toString().padLeft(2, "0")}:${PomodoroData.time[PomodoroData.status + 1].toString().padLeft(2, "0")}",
                            style: TextStyle(
                                fontSize: (Device.screenWidth / 8).round() * 1,
                                color: Colors.white,
                                fontWeight: Device.menuFont),
                          ),
                          Text(
                            PomodoroData.timerName[PomodoroData.status ~/ 2],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: Device.menuFont),
                          )
                        ],
                      ),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(PomodoroData.sets, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4),
                        child: (PomodoroData.completedSets > index)
                            ? Icon(
                                CustomIcons.pomodoroCompleted,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryFixed,
                                size: 40,
                              )
                            : Icon(
                                CustomIcons.pomodoro,
                                color: Colors.white,
                                size: 40,
                              ),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: (Device.screenHeight / 70).round() * 1),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(
                          () {
                            PomodoroData.isRunning = !PomodoroData.isRunning;
                          },
                        );
                        sqlDB.update(
                          "PomodoroData",
                          {'isRunning': toInt(PomodoroData.isRunning)},
                          'id=?',
                          [1],
                        );
                        if (PomodoroData.isRunning) {
                          if (PomodoroData.completedSets == PomodoroData.sets) {
                            setState(() {
                              PomodoroData.timer = DateTime(
                                0,
                                0,
                                0,
                                0,
                                PomodoroData.endTimer[0],
                                PomodoroData.endTimer[1],
                              );
                            });
                            await resetTimer();
                          }
                          PomodoroData.periodicTimer?.cancel();
                          runTimerLocally(setState);
                        } else {
                          PomodoroData.periodicTimer?.cancel();
                        }
                      },
                      child: Text(
                        PomodoroData.isRunning ? "Pause" : "Start",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: Device.menuFont),
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await resetTimer();
                      PomodoroData.isRunning = false;
                      PomodoroData.periodicTimer?.cancel();
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Text(
                        "Reset",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: Device.menuFont),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

Future<void> runTimerLocally(Function updateUi) async {
  PomodoroData.periodicTimer = Timer.periodic(
    Duration(seconds: 1),
    (t) async {
      updateUi(
        () {
          runTimer();
        },
      );
    },
  );
}

Future<void> runTimerRemotely() async {
  PomodoroData.periodicTimer = Timer.periodic(
    Duration(seconds: 1),
    (t) async {
      await runTimer();
    },
  );
}

Future<void> resetTimer() async {
  PomodoroData.completedSets = 0;
  PomodoroData.progress = 0;
  PomodoroData.status = 0;
  PomodoroData.timer = DateTime(
    0,
    0,
    0,
    0,
    PomodoroData.endTimer[PomodoroData.status],
    PomodoroData.endTimer[PomodoroData.status + 1],
  );
  PomodoroData.time = List.from(PomodoroData.endTimer);

  await UpdatePomodoro();
}

Future<void> runTimer() async {
  if (PomodoroData.isRunning &&
      (PomodoroData.timer.minute > 0 || PomodoroData.timer.second > 0)) {
    PomodoroData.timer = PomodoroData.timer.subtract(Duration(seconds: 1));
    PomodoroData.progress = 1 -
        (PomodoroData.timer.minute * 60 + PomodoroData.timer.second) /
            (PomodoroData.endTimer[PomodoroData.status] * 60 +
                PomodoroData.endTimer[PomodoroData.status + 1]);
    PomodoroData.time[PomodoroData.status] = PomodoroData.timer.minute;
    PomodoroData.time[PomodoroData.status + 1] = PomodoroData.timer.second;
  } else if ((PomodoroData.completedSets + 1) % PomodoroData.breakSet == 0 &&
      PomodoroData.status == 0) {
    if (MainData.isVibrationOn) {
      HapticFeedback.vibrate();
    }
    PomodoroData.status += 4;
    PomodoroData.completedSets++;
    PomodoroData.timer = DateTime(
      0,
      0,
      0,
      0,
      PomodoroData.endTimer[PomodoroData.status],
      PomodoroData.endTimer[PomodoroData.status + 1],
    );
  } else if (PomodoroData.isRunning &&
      PomodoroData.completedSets < PomodoroData.sets &&
      PomodoroData.status < 2) {
    if (MainData.isVibrationOn) {
      HapticFeedback.vibrate();
    }
    PomodoroData.status += 2;
    PomodoroData.timer = DateTime(
      0,
      0,
      0,
      0,
      PomodoroData.endTimer[PomodoroData.status],
      PomodoroData.endTimer[PomodoroData.status + 1],
    );
  } else if (PomodoroData.isRunning &&
      PomodoroData.completedSets != PomodoroData.sets &&
      PomodoroData.completedSets % PomodoroData.breakSet == 0 &&
      PomodoroData.status == 4) {
    if (MainData.isVibrationOn) {
      HapticFeedback.vibrate();
    }
    PomodoroData.status = 0;
    PomodoroData.timer = DateTime(
      0,
      0,
      0,
      0,
      PomodoroData.endTimer[PomodoroData.status],
      PomodoroData.endTimer[PomodoroData.status + 1],
    );
  } else if (PomodoroData.isRunning &&
      PomodoroData.completedSets == PomodoroData.sets &&
      PomodoroData.completedSets % PomodoroData.breakSet == 0 &&
      PomodoroData.status == 0) {
    if (MainData.isVibrationOn) {
      HapticFeedback.vibrate();
    }
    PomodoroData.status = 4;
    PomodoroData.timer = DateTime(
      0,
      0,
      0,
      0,
      PomodoroData.endTimer[PomodoroData.status],
      PomodoroData.endTimer[PomodoroData.status + 1],
    );
  } else if (PomodoroData.completedSets != PomodoroData.sets &&
      (PomodoroData.status == 2 || PomodoroData.status == 4)) {
    if (MainData.isVibrationOn) {
      HapticFeedback.vibrate();
    }
    PomodoroData.status = 0;
    PomodoroData.completedSets++;
    PomodoroData.timer = DateTime(
      0,
      0,
      0,
      0,
      PomodoroData.endTimer[PomodoroData.status],
      PomodoroData.endTimer[PomodoroData.status + 1],
    );
  }
  if (PomodoroData.completedSets == PomodoroData.sets) {
    if (MainData.isVibrationOn) {
      HapticFeedback.vibrate();
    }
    PomodoroData.isRunning = false;
    PomodoroData.periodicTimer?.cancel();
  }
  await UpdatePomodoro();
}
