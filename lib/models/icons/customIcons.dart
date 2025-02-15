library;

import 'package:flutter/widgets.dart';

class CustomIcons {
  CustomIcons._();

  static const _kFontFam1 = 'Inbox';
  static const _kFontFam2 = 'Today';
  static const _kFontFam3 = 'Pomodoro';
  static const _kFontFam4 = 'Archieve';
  static const _kFontFam5 = 'Settings';
  static const _kFontFam6 = 'PomodoroCompleted';
  static const _kFontFam7 = 'EditPomodoro';
  static const _kFontFam8 = 'Clist';

  static const String? _kFontPkg = null;

  static const IconData inbox =
      IconData(0xe801, fontFamily: _kFontFam1, fontPackage: _kFontPkg);
  static const IconData calendar =
      IconData(0xe800, fontFamily: _kFontFam2, fontPackage: _kFontPkg);
  static const IconData pomodoro =
      IconData(0xe802, fontFamily: _kFontFam3, fontPackage: _kFontPkg);
  static const IconData archive =
      IconData(0xe800, fontFamily: _kFontFam4, fontPackage: _kFontPkg);
  static const IconData settings =
      IconData(0xe800, fontFamily: _kFontFam5, fontPackage: _kFontPkg);
  static const IconData pomodoroCompleted =
      IconData(0xe800, fontFamily: _kFontFam6, fontPackage: _kFontPkg);
  static const IconData editPomodoro =
      IconData(0xe801, fontFamily: _kFontFam7, fontPackage: _kFontPkg);
  static const IconData list =
      IconData(0xe800, fontFamily: _kFontFam8, fontPackage: _kFontPkg);
}
