import 'package:flutter/material.dart';

class themeDetails {
  ThemeData themeData;
  String themename;
  Color background;
  Color ButtonBack;
  Color ButtonFor;
  bool selected;
  themeDetails({
    required this.themeData,
    required this.themename,
    required this.background,
    required this.ButtonBack,
    required this.ButtonFor,
    required this.selected,
  });
}
