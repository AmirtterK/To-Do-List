import 'dart:async';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/services/database/DataBase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class notificationsService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController();

  @pragma('vm:entry-point')
  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.actionId == 'id_1') {
      await setCompletedTask(notificationResponse);
    }
    streamController.add(notificationResponse);
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSinitializationSetting =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSinitializationSetting,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  static Future<void> ScheduleNotification(
      int id, String title, String body, DateTime reminder) async {
    tz.initializeTimeZones();
    NotificationDetails PlatformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        title,
        body,
        importance: Importance.max,
        priority: Priority.high,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'id_1',
            'completed',
            cancelNotification: true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(reminder, tz.local), PlatformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: null,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  static Future<void> showBasicNotification() async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
      'id 1',
      'basic notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Basic Notification',
      'body',
      details,
      payload: "Payload Data",
    );
  }
}

Future<void> setCompletedTask(NotificationResponse notificationResponse) async {
  List<Map<String, dynamic>> response = await sqlDB
      .search('InboxTodos', 'reminderId=?', [notificationResponse.id]);
  if (response.isNotEmpty) {
    if (1 ==
        await sqlDB.update('InboxTodos', {'completed': 1}, 'reminderId=?',
            [notificationResponse.id])) {
      await fetchCompletedTasksNumber('InboxTodos');

      return;
    }
  }

  response = await sqlDB
      .search('TodayTodos', 'reminderId=?', [notificationResponse.id]);

  if (1 ==
      await sqlDB.update('TodayTodos', {'completed': 1}, 'reminderId=?',
          [notificationResponse.id])) {
    await fetchCompletedTasksNumber('TodayTodos');

    return;
  }

  await fetchLists();
  for (var Clist in MainData.customlist) {
    response = await sqlDB.search(
        '${Clist.ListName}Todos', 'reminderId=?', [notificationResponse.id]);
    if (response.isNotEmpty) {
      await sqlDB.update('${Clist.ListName}Todos', {'completed': 1},
          'reminderId=?', [notificationResponse.id]);

      return;
    }
  }
}
