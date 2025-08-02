import 'dart:async';

import 'package:to_do_list/dialogs/NewListDialog.dart';
import 'package:to_do_list/dialogs/NewTaskDialog.dart';
import 'package:to_do_list/models/classes/customListClass.dart';
import 'package:to_do_list/models/classes/onBoardClass.dart';
import 'package:to_do_list/models/icons/customIcons.dart';

import 'package:to_do_list/models/classes/menuClass.dart';
import 'package:to_do_list/services/database/maps.dart';
import 'package:to_do_list/services/notifications/workmanager.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

import '../../models/classes/taskClass.dart';
import 'DataBase.dart';

SqlDB sqlDB = SqlDB();

class MainData {
  static List<ToDo> Today_tasks_list = [];
  static List<ToDo> inbox_tasks_list = [];
  static List<ToDo> archived_tasks_list = [];
  static int completed_inbox_tasks = 0;
  static int completed_Today_tasks = 0;
  static int ReminderId = 1;
  static double inbox_progress = 1;
  static double Today_progress = 1;
  static String selectedTheme = "Dark";
  static bool startOnBoard = true;
  static List<Customlist> customlist = [];
  static List<ToDo> selectedList = [];
  static List<MenuItem> MenuItems = [
    MenuItem(
        Row(
          key: ValueKey(MainData.inbox_progress),
          children: [
            Text(
              'Inbox',
              style: TextStyle(
                fontSize: 18,
                fontWeight: Device.menuFont,
              ),
            ),
            !Device.desktopPlatform ? const Spacer() : SizedBox(),
            !Device.desktopPlatform
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: CircularPercentIndicator(
                      radius: 16,
                      percent: MainData.inbox_progress,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 1500,
                      progressColor: const Color.fromARGB(255, 234, 0, 210),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  )
                : SizedBox(),
          ],
        ),
        Icon(
          CustomIcons.inbox,
          size: 26,
        ),
        'Inbox'),
    MenuItem(
        Row(
          key: ValueKey(MainData.Today_progress),
          children: [
            Text(
              'Today',
              style: TextStyle(
                fontSize: 18,
                fontWeight: Device.menuFont,
              ),
            ),
            !Device.desktopPlatform ? const Spacer() : SizedBox(),
            !Device.desktopPlatform
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: CircularPercentIndicator(
                      radius: 16,
                      percent: MainData.Today_progress,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 1500,
                      progressColor: const Color.fromARGB(255, 122, 39, 254),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  )
                : SizedBox(),
          ],
        ),
        Icon(
          CustomIcons.calendar,
          size: 26,
        ),
        'Today'),
    MenuItem(
        Text(
          'Pomodoro',
          style: TextStyle(
            fontSize: 18,
            fontWeight: Device.menuFont,
          ),
        ),
        Icon(
          CustomIcons.pomodoro,
          size: 28,
        ),
        'Pomodoro'),
    MenuItem(
        Text(
          'Archive',
          style: TextStyle(
            fontSize: 18,
            fontWeight: Device.menuFont,
          ),
        ),
        Icon(
          CustomIcons.archive,
          size: 28,
        ),
        'Archive'),
    MenuItem(
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: Device.menuFont,
          ),
        ),
        Icon(
          CustomIcons.settings,
          size: 28,
        ),
        'Settings'),
  ];
  static List<String> labels = ["work", "study", "home"];
  static bool saved = false;
  static String flag = "";
  static bool labelChanged = false;
  static bool isAllarmOn = false;
  static bool isVibrationOn = true;

  static String about =
      "Swift List: To-Do List & Pomodoro App. This is the first app I built, marking the start of my journey in Flutter. Many features were challenging to implement due to the lack of documentation. Even now some of them may not work as intended. However once I took on the challenge I was determined to finish it. All it took was consistency and dedication.";
}

class Device {
  static bool desktopPlatform = false;
  static bool isThemePageDesktop = false;
  static bool isEditPomodoroDesktop = false;
  static late double screenHeight;
  static late double screenWidth;
  static int pixelRatio = 0;
  static GlobalKey rail_key = GlobalKey();
  static FontWeight menuFont = FontWeight.w400;

  static bool changed = false;

  static bool settingsVisited = false;

  static double getRailWidth() {
    final RenderBox renderBox =
        rail_key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.width;
  }
}

class PomodoroData {
  static List<int> time = [25, 0, 5, 0, 30, 5];
  static List<int> endTimer = [25, 0, 5, 0, 30, 5];
  static List<String> timerName = ["WORK", "BREAK", "LONG BREAK"];
  static int sets = 6;
  static int completedSets = 0;
  static int breakSet = 3;
  static double progress = 0;
  static int status = 0;
  static bool isRunning = false;
  static Timer? periodicTimer;
  static DateTime timer = DateTime(
    0,
    0,
    0,
    0,
    PomodoroData.time[PomodoroData.status],
    PomodoroData.time[PomodoroData.status + 1],
  );
}

void UpdateInboxProgress() async {
  MainData.inbox_progress = MainData.inbox_tasks_list.isEmpty
      ? 1
      : MainData.completed_inbox_tasks / MainData.inbox_tasks_list.length;
  await sqlDB.update(
      'MainData',
      {
        'inbox_progress': MainData.inbox_progress,
        'completed_inbox_tasks': MainData.completed_inbox_tasks
      },
      'id=?',
      [1]);
  await updateInboxProgressIndicators();
}

Future<void> UpdateTodayProgress() async {
  MainData.Today_progress = MainData.Today_tasks_list.isEmpty
      ? 1
      : MainData.completed_Today_tasks / MainData.Today_tasks_list.length;
  await sqlDB.update(
      'MainData',
      {
        'Today_progress': MainData.Today_progress,
        'completed_Today_tasks': MainData.completed_Today_tasks
      },
      'id=?',
      [1]);
  await updateTodayProgressIndicators();
}

Future<void> updateInboxProgressIndicators() async {
  MainData.MenuItems[0].content = Row(
    key: ValueKey(MainData.inbox_progress),
    children: [
      Text(
        'Inbox',
        style: TextStyle(
          fontSize: 18,
          fontWeight: Device.menuFont,
        ),
      ),
      !Device.desktopPlatform ? const Spacer() : SizedBox(),
      !Device.desktopPlatform
          ? Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CircularPercentIndicator(
                radius: 16,
                percent: MainData.inbox_progress,
                animation: true,
                animateFromLastPercent: true,
                animationDuration: 1500,
                progressColor: const Color.fromARGB(255, 234, 0, 210),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            )
          : SizedBox(),
    ],
  );
}

Future<void> updateTodayProgressIndicators() async {
  MainData.MenuItems[1].content = Row(
    key: ValueKey(MainData.Today_progress),
    children: [
      Text(
        'Today',
        style: TextStyle(
          fontSize: 18,
          fontWeight: Device.menuFont,
        ),
      ),
      !Device.desktopPlatform ? const Spacer() : SizedBox(),
      !Device.desktopPlatform
          ? Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CircularPercentIndicator(
                radius: 16,
                percent: MainData.Today_progress,
                animation: true,
                animateFromLastPercent: true,
                animationDuration: 1500,
                progressColor: const Color.fromARGB(255, 122, 39, 254),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            )
          : SizedBox(),
    ],
  );
}

Future<void> UpdatePomodoro() async {
  await sqlDB.update(
    'PomodoroData',
    PomodoroMap(),
    'id=?',
    [1],
  );
}

List<OnboardData> displayPage = [
  OnboardData(
      "Welcome to Swift List", "to do list &\n task management app", "ss1.svg"),
  OnboardData("Simple and fast", "Create your to-dos easily", "ss2.svg"),
  OnboardData(
      "Pomodoro", "set a perfect pace according to \nyour needs", "ss3.svg"),
];

List<String> reminderNotes = [
  "hurry up!",
  "don't forget your task!",
  "it's time",
  "it's almost over!",
  "a task is left"
];

Future<void> cancelNotification(int id) async {
  try {
    await WorkManagerService().cancleTask(id.toString());
  } catch (e) {}
}

bool task_changed(ToDo task_1, ToDo task_2) {
  return !((task_1.title == task_2.title) &&
      (task_1.description == task_2.description) &&
      ((task_1.timeReminder.compareTo(task_2.timeReminder)) == 0) &&
      (task_1.ReminderOn == task_2.ReminderOn) &&
      (task_1.completed == task_2.completed) &&
      (task_1.label == task_2.label));
}

Future<bool> isAlarmAllowed() async {
  var status = await Permission.notification.status;
  return !(status.isDenied || status.isPermanentlyDenied);
}

int toInt(bool completed) => completed ? 1 : 0;

Future<ToDo?> displayNewTaskDialog(BuildContext context) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    anchorPoint: Offset.zero,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
    transitionDuration: const Duration(milliseconds: 170),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(animation),
          child: const NewTaskDialog(),
        ),
      );
    },
  );
}

Future<void> resetAllarm() async {
  DateTime now = DateTime.now();
  if (Device.desktopPlatform) {
    return;
  }
  if (MainData.isAllarmOn) {
    MainData.inbox_tasks_list
        .where((task) =>
            task.ReminderOn &&
            task.timeReminder.isAfter(now) &&
            !task.completed)
        .forEach((task) async => await Workmanager().registerOneOffTask(
            task.reminderId.toString(), "notification",
            inputData: TodoMap(task)));
    MainData.Today_tasks_list.where((task) =>
            task.ReminderOn &&
            task.timeReminder.isAfter(now) &&
            !task.completed)
        .forEach((task) async => await Workmanager().registerOneOffTask(
            task.reminderId.toString(), "notification",
            inputData: TodoMap(task)));
    for (var Clist in MainData.customlist) {
      for (var task in Clist.list) {
        await Workmanager().registerOneOffTask(
            task.reminderId.toString(), "notification",
            inputData: TodoMap(task));
      }
    }
  } else {
    MainData.inbox_tasks_list
        .where((task) =>
            task.ReminderOn &&
            task.timeReminder.isAfter(now) &&
            !task.completed)
        .forEach((task) async => await cancelNotification(task.reminderId));
    MainData.Today_tasks_list.where((task) =>
            task.ReminderOn &&
            task.timeReminder.isAfter(now) &&
            !task.completed)
        .forEach((task) async => await cancelNotification(task.reminderId));
    for (var Clist in MainData.customlist) {
      for (var task in Clist.list) {
        await cancelNotification(task.reminderId);
      }
    }
  }
}

Future<Customlist?> displayNewListDialog(BuildContext context) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    anchorPoint: Offset.zero,
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
    transitionDuration: const Duration(milliseconds: 170),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(animation),
          child: const NewlistDialog(),
        ),
      );
    },
  );
}

Future<void> ResetData() async {
  if (MainData.isAllarmOn) {
    MainData.isAllarmOn = false;
    await resetAllarm();
    MainData.isAllarmOn = true;
  }

  MainData.completed_inbox_tasks = 0;
  MainData.completed_Today_tasks = 0;
  MainData.inbox_progress = 1;
  MainData.Today_progress = 1;
  MainData.ReminderId = 1;
  MainData.saved = false;
  MainData.flag = "";
  MainData.labelChanged = false;
  MainData.Today_tasks_list.clear();
  MainData.inbox_tasks_list.clear();
  Device.isThemePageDesktop = false;
  Device.isEditPomodoroDesktop = false;

  PomodoroData.time = [25, 0, 5, 0, 30, 5];
  PomodoroData.endTimer = [25, 0, 5, 0, 30, 5];
  PomodoroData.sets = 6;
  PomodoroData.completedSets = 0;
  PomodoroData.breakSet = 3;
  PomodoroData.progress = 0;
  PomodoroData.status = 0;
  PomodoroData.isRunning = false;
  PomodoroData.periodicTimer;
  PomodoroData.timer = DateTime(
    0,
    0,
    0,
    0,
    PomodoroData.time[PomodoroData.status],
    PomodoroData.time[PomodoroData.status + 1],
  );

  MainData.MenuItems = [
    MenuItem(
        Row(
          key: ValueKey(MainData.inbox_progress),
          children: [
            Text(
              'Inbox',
              style: TextStyle(
                fontSize: 18,
                fontWeight: Device.menuFont,
              ),
            ),
            !Device.desktopPlatform ? const Spacer() : SizedBox(),
            !Device.desktopPlatform
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: CircularPercentIndicator(
                      radius: 16,
                      percent: MainData.inbox_progress,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 1500,
                      progressColor: const Color.fromARGB(255, 234, 0, 210),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  )
                : SizedBox(),
          ],
        ),
        Icon(
          CustomIcons.inbox,
          size: 26,
        ),
        'Inbox'),
    MenuItem(
        Row(
          key: ValueKey(MainData.Today_progress),
          children: [
            Text(
              'Today',
              style: TextStyle(
                fontSize: 18,
                fontWeight: Device.menuFont,
              ),
            ),
            !Device.desktopPlatform ? const Spacer() : SizedBox(),
            !Device.desktopPlatform
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: CircularPercentIndicator(
                      radius: 16,
                      percent: MainData.Today_progress,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 1500,
                      progressColor: const Color.fromARGB(255, 122, 39, 254),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  )
                : SizedBox(),
          ],
        ),
        Icon(
          CustomIcons.calendar,
          size: 26,
        ),
        'Today'),
    MenuItem(
        Text(
          'Pomodoro',
          style: TextStyle(
            fontSize: 18,
            fontWeight: Device.menuFont,
          ),
        ),
        Icon(
          CustomIcons.pomodoro,
          size: 28,
        ),
        'Pomodoro'),
    MenuItem(
        Text(
          'Archive',
          style: TextStyle(
            fontSize: 18,
            fontWeight: Device.menuFont,
          ),
        ),
        Icon(
          CustomIcons.archive,
          size: 28,
        ),
        'Archive'),
    MenuItem(
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: Device.menuFont,
          ),
        ),
        Icon(
          CustomIcons.settings,
          size: 28,
        ),
        'Settings'),
  ];
  await sqlDB.deleteMain("MainData");
  for (var table in MainData.customlist) {
    await sqlDB.deleteTable('${table.ListName}Todos');
  }

  await sqlDB.deleteMain("PomodoroData");
  await sqlDB.deleteAll("Today");
  await sqlDB.deleteAll("Inbox");
  await sqlDB.deleteAll("Archived");
  await sqlDB.deleteMain("customeList");
  MainData.customlist.clear();
  await fetchMainData('mainData');
  await fetchPomodoroData("PomodoroData");
}
