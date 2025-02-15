import 'package:to_do_list/services/database/AppData.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay> selectTime(BuildContext context, String timeReminder) async {
  TimeOfDay selectedTime = TimeOfDay.now();

  if (timeReminder.isNotEmpty) {
    selectedTime = TimeOfDay(
        hour: DateTime.parse(timeReminder).hour,
        minute: DateTime.parse(timeReminder).minute);
  }
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: selectedTime,
  );

  if (pickedTime != null) {
    selectedTime = pickedTime;
    MainData.saved = true;
  }
  return selectedTime;
}
