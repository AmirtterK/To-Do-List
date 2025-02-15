import '../../models/classes/taskClass.dart';
import 'AppData.dart';

Map<String, Object> TodoMap(ToDo response) {
  return {
    'title': response.title,
    'description': response.description,
    'completed': toInt(response.completed),
    'ReminderOn': toInt(response.ReminderOn),
    'creationDate': response.creationDate.toString(),
    'timeReminder': response.timeReminder.toString(),
    'reminderId': response.reminderId,
    'label': response.label
  };
}

Map<String, Object> mainMap() {
  return {
    'completed_inbox_tasks': MainData.completed_inbox_tasks,
    'completed_Today_tasks': MainData.completed_Today_tasks,
    'inbox_progress': MainData.inbox_progress,
    'Today_progress': MainData.Today_progress,
    'selectedTheme': MainData.selectedTheme,
    'startOnBoard': toInt(MainData.startOnBoard),
    'ReminderId': MainData.ReminderId,
    'isAllarmOn': toInt(MainData.isAllarmOn),
    'isVibrationOn': toInt(MainData.isVibrationOn),
    'pixelratio': Device.pixelRatio,
  };
}

Map<String, Object> PomodoroMap() {
  return {
    'work_minut': PomodoroData.endTimer[0],
    'work_second': PomodoroData.endTimer[1],
    'rest_minut': PomodoroData.endTimer[2],
    'rest_second': PomodoroData.endTimer[3],
    'break_minut': PomodoroData.endTimer[4],
    'break_second': PomodoroData.endTimer[5],
    'Cwork_minut': PomodoroData.time[0],
    'Cwork_second': PomodoroData.time[1],
    'Crest_minut': PomodoroData.time[2],
    'Crest_second': PomodoroData.time[3],
    'Cbreak_minut': PomodoroData.time[4],
    'Cbreak_second': PomodoroData.time[5],
    'sets': PomodoroData.sets,
    'completedSets': PomodoroData.completedSets,
    'breakSet': PomodoroData.breakSet,
    'status': PomodoroData.status,
    'isRunning': toInt(PomodoroData.isRunning),
    'progress': PomodoroData.progress,
  };
}
