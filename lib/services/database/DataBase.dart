import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_list/models/classes/customListClass.dart';
import 'package:to_do_list/models/classes/menuClass.dart';
import 'package:to_do_list/models/icons/customIcons.dart';
import 'package:workmanager/workmanager.dart';

import '../../models/classes/taskClass.dart';
import 'AppData.dart';
import 'maps.dart';

class SqlDB {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'SwiftList.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  void _onUpgrade(Database db, int oldversion, int newversion) {
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "InboxTodos"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT ,
    "title" TEXT NOT NULL ,
    "description" TEXT ,
    "completed" INTEGER NOT NULL ,
    "ReminderOn" INTEGER NOT NULL ,
    "creationDate" TEXT NOT NULL,
    "timeReminder" Text NOT NULL,
    "reminderId" INTEGER NOT NULL,
    "label" TEXT NOT NULL
    )
''');

    await db.execute('''
    CREATE TABLE "TodayTodos"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT ,
    "title" TEXT NOT NULL ,
    "description" TEXT ,
    "completed" INTEGER NOT NULL ,
    "ReminderOn" INTEGER NOT NULL ,
    "creationDate" TEXT NOT NULL,
    "timeReminder" Text NOT NULL,
    "reminderId" INTEGER NOT NULL,
    "label" TEXT NOT NULL
    )
''');

    await db.execute('''
    CREATE TABLE "customeList"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT ,
    "title" TEXT NOT NULL
    )
''');

    await db.execute('''
    CREATE TABLE "ArchivedTodos"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT ,
    "title" TEXT NOT NULL ,
    "description" TEXT ,
    "completed" INTEGER NOT NULL ,
    "ReminderOn" INTEGER NOT NULL ,
    "creationDate" TEXT NOT NULL,
    "timeReminder" Text NOT NULL,
    "reminderId" INTEGER NOT NULL,
    "label" TEXT NOT NULL
    )
''');

    await db.execute('''
    CREATE TABLE "MainData"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT , 
    "completed_inbox_tasks" INTEGER NOT NULL ,
    "completed_Today_tasks" INTEGER NOT NULL ,
    "inbox_progress" REAL NOT NULL , 
    "Today_progress" REAL NOT NULL ,
    "selectedTheme" TEXT NOT NULL ,
    "startOnBoard" INTEGER NOT NULL ,
    "ReminderId" INTEGER NOT NULL ,
    "isAllarmOn" INTEGER NOT NULL ,
    "isVibrationOn" INTEGER NOT NULL ,
    "pixelratio" INTEGER NOT NULL
    )
''');
    await db.execute('''
    CREATE TABLE "PomodoroData"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT ,
    "work_minut" INTEGER NOT NULL ,
    "work_second" INTEGER NOT NULL ,
    "rest_minut" INTEGER NOT NULL , 
    "rest_second" INTEGER NOT NULL ,
    "break_minut" INTEGER NOT NULL ,
    "break_second" INTEGER NOT NULL ,
    "Cwork_minut" INTEGER NOT NULL ,
    "Cwork_second" INTEGER NOT NULL ,
    "Crest_minut" INTEGER NOT NULL , 
    "Crest_second" INTEGER NOT NULL ,
    "Cbreak_minut" INTEGER NOT NULL ,
    "Cbreak_second" INTEGER NOT NULL ,
    "sets" INTEGER NOT NULL ,
    "completedSets" INTEGER NOT NULL ,
    "breakSet" INTEGER NOT NULL ,
    "status" INTEGER NOT NULL,
    "isRunning" INTEGER NOT NULL ,
    "progress" REAL NOT NULL
    )
''');
  }

  Future<void> createNewTable(String table) async {
    Database? mydb = await db;
    await mydb?.execute('''
    CREATE TABLE "${table}Todos"(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT ,
    "title" TEXT NOT NULL ,
    "description" TEXT ,
    "completed" INTEGER NOT NULL ,
    "ReminderOn" INTEGER NOT NULL ,
    "creationDate" TEXT NOT NULL,
    "timeReminder" Text NOT NULL,
    "reminderId" INTEGER NOT NULL,
    "label" TEXT NOT NULL
    )
''');
  }

  Future<List<Map>> readData(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  Future<List<Map>> search(String table, String whereVal, List val) async {
    Database? mydb = await db;
    List<Map> response =
        await mydb!.query(table, where: whereVal, whereArgs: val);
    return response;
  }

  Future<int> insert(String table, Map<String, Object> values) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, values);
    return response;
  }

  Future<int> update(String table, Map<String, Object> values, String whereVal,
      List val) async {
    Database? mydb = await db;
    int response =
        await mydb!.update(table, values, where: whereVal, whereArgs: val);
    return response;
  }

  Future<int> delete(String table, String whereVal, List val) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: whereVal, whereArgs: val);
    return response;
  }

  Future<int> deleteAll(String table) async {
    String tableName = '${table}Todos';
    Database? mydb = await db;
    int response = await mydb!.delete(tableName);
    await mydb.execute('DELETE FROM sqlite_sequence WHERE name = "$tableName"');
    return response;
  }

  Future<int> deleteMain(String table) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table);
    await mydb.execute('DELETE FROM sqlite_sequence WHERE name = "$table"');
    return response;
  }

  Future<void> deleteTable(String tableName) async {
    Database? mydb = await db;
    await mydb!.execute('DROP TABLE IF EXISTS $tableName');
  }
}

Future<void> removeFromDb(String table, ToDo current_task) async {
  String tableName = '${table}Todos';
  if (current_task.ReminderOn && !Device.desktopPlatform) {
    await cancelNotification(current_task.reminderId);
  }
  await sqlDB.delete(
      tableName, 'creationDate=?', [current_task.creationDate.toString()]);
}

Future<void> insertInDb(String table, ToDo current_task) async {
  String tableName = '${table}Todos';

  if (current_task.ReminderOn &&
      !current_task.completed &&
      !Device.desktopPlatform) {
    Workmanager().registerOneOffTask(
        current_task.reminderId.toString(), "notification",
        inputData: TodoMap(current_task));
  }
  await sqlDB.update(
      'MainData',
      {
        'ReminderId': MainData.ReminderId,
      },
      'id=?',
      [1]);
  await sqlDB.insert(tableName, TodoMap(current_task));
}

Future<void> fetchData(String table, List<ToDo> todos) async {
  List<Map> response = await SqlDB().readData(table);
  for (var element in response) {
    ToDo RestoreTask = ToDo(
      element['title'],
      element['description'],
      (element['completed'] == 1),
      (element['ReminderOn'] == 1),
      DateTime.parse(element['creationDate']),
      DateTime.parse(element['timeReminder']),
      element['reminderId'],
      element['label'],
    );
    todos.add(RestoreTask);
  }
}

Future<void> fetchLists() async {
  List<Map> response = await SqlDB().readData('customeList');

  for (var element in response) {
    MainData.customlist.add(Customlist(element['title'], []));
  }
  MainData.customlist
      .where((Clist) => Clist.ListName.isNotEmpty)
      .forEach((Clist) async {
    await fetchData("${Clist.ListName}Todos", Clist.list);
    int index =
        MainData.MenuItems.indexWhere((item) => item.location == 'Archive');
    MainData.MenuItems.insert(
        index,
        MenuItem(
          Text(
            Clist.ListName.replaceAll('_', ' ').replaceAll('dotmark', '.'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: Device.menuFont,
            ),
          ),
          Icon(CustomIcons.list, size: 28),
          Clist.ListName,
        ));
  });
}

Future<void> fetchMainData(
  String table,
) async {
  List<Map> response = await SqlDB().readData(table);
  if (response.isNotEmpty) {
    MainData.completed_inbox_tasks = response[0]['completed_inbox_tasks'];
    MainData.completed_Today_tasks = response[0]['completed_Today_tasks'];
    MainData.inbox_progress = response[0]['inbox_progress'];
    MainData.Today_progress = response[0]['Today_progress'];
    MainData.selectedTheme = response[0]['selectedTheme'];
    MainData.startOnBoard = (response[0]['startOnBoard'] == 1);
    MainData.ReminderId = response[0]['ReminderId'];
    MainData.isAllarmOn = (response[0]['isAllarmOn'] == 1);
    MainData.isVibrationOn = (response[0]['isVibrationOn'] == 1);
    Device.pixelRatio = response[0]['pixelratio'];
  } else {
    sqlDB.insert(table, mainMap());
  }
}

Future<void> fetchPomodoroData(
  String table,
) async {
  List<Map> response = await SqlDB().readData(table);
  if (response.isNotEmpty) {
    PomodoroData.endTimer[0] = response[0]['work_minut'];
    PomodoroData.endTimer[1] = response[0]['work_second'];
    PomodoroData.endTimer[2] = response[0]['rest_minut'];
    PomodoroData.endTimer[3] = response[0]['rest_second'];
    PomodoroData.endTimer[4] = response[0]['break_minut'];
    PomodoroData.endTimer[5] = response[0]['break_second'];
    PomodoroData.time[0] = response[0]['Cwork_minut'];
    PomodoroData.time[1] = response[0]['Cwork_second'];
    PomodoroData.time[2] = response[0]['Crest_minut'];
    PomodoroData.time[3] = response[0]['Crest_second'];
    PomodoroData.time[4] = response[0]['Cbreak_minut'];
    PomodoroData.time[5] = response[0]['Cbreak_second'];
    PomodoroData.sets = response[0]['sets'];
    PomodoroData.completedSets = response[0]['completedSets'];
    PomodoroData.breakSet = response[0]['breakSet'];
    PomodoroData.isRunning = (response[0]['isRunning'] == 1);
    PomodoroData.progress = response[0]['progress'];
  } else {
    sqlDB.insert(table, PomodoroMap());
  }
}

Future<void> fetchCompletedTasksNumber(String table) async {
  List<Map> response = await SqlDB().readData('MainData');

  List<Map> Tasks = await SqlDB().readData(table);
  await fetchPixelRatio();
  int TasksNum = Tasks.length;
  switch (table) {
    case 'InboxTodos':
      MainData.completed_inbox_tasks = response[0]['completed_inbox_tasks'];
      MainData.inbox_progress = response[0]['inbox_progress'];
      MainData.completed_inbox_tasks++;
      MainData.inbox_progress = MainData.completed_inbox_tasks / TasksNum;

      await sqlDB.update(
        'MainData',
        {
          'inbox_progress': MainData.inbox_progress,
          'completed_inbox_tasks': MainData.completed_inbox_tasks
        },
        'id=?',
        [1],
      );
      updateInboxProgressIndicators();
      break;
    case 'TodayTodos':
      MainData.completed_Today_tasks = response[0]['completed_Today_tasks'];
      MainData.Today_progress = response[0]['Today_progress'];
      MainData.completed_Today_tasks++;
      MainData.Today_progress = MainData.completed_Today_tasks / TasksNum;
      await sqlDB.update(
        'MainData',
        {
          'today_progress': MainData.Today_progress,
          'completed_Today_tasks': MainData.completed_Today_tasks
        },
        'id=?',
        [1],
      );

      updateTodayProgressIndicators();
      break;
    default:
  }
}

Future<void> fetchReminerId(String table) async {
  List<Map> response = await SqlDB().readData(table);
  MainData.ReminderId = response[0]['ReminderId'];
}

Future<void> fetchPixelRatio() async {
  List<Map> response = await SqlDB().readData('MainData');
  Device.pixelRatio = response[0]['pixelratio'];
}
