import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/services/notifications/notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:math';

class WorkManagerService {
  void RegisterTask() {
    Workmanager().registerOneOffTask("id1", "show simple notification");
  }

  Future<void> cancleTask(String id) async {
    await Workmanager().cancelByUniqueName(id);
    await notificationsService.flutterLocalNotificationsPlugin
        .cancel(int.parse(id));
  }
}

@pragma('vm:entry-point')
void callBackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputData) async {
      try {
        await notificationsService.ScheduleNotification(
          inputData!['reminderId'],
          inputData['title'],
          reminderNotes[Random().nextInt(reminderNotes.length)],
          DateTime.parse(
            inputData['timeReminder'],
          ),
        );
      } catch (e) {}

      return Future.value(true);
    },
  );
}

Future<void> initializeWorkmanager() async {
  try {
    await Future.delayed(const Duration(milliseconds: 100));

    await Workmanager().initialize(
      callBackDispatcher,
    );
  } catch (e) {
    // i couldn't fix the channel error so no notifications i really tried
    // print('Workmanager initialization failed: $e');
  }
}
