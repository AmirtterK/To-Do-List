import 'package:flutter/material.dart';
import 'package:to_do_list/services/database/AppData.dart';

SnackBar ReminderSnackbar() {
  return SnackBar(
    content: Text(
      'reminder set',
      style: TextStyle(fontWeight: Device.menuFont),
    ),
    behavior: SnackBarBehavior.floating,
    width: 200,
  );
}
