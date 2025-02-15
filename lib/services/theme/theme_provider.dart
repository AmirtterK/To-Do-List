import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/services/theme/Themes.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;

  ThemeData currentTheme() {
    return _themeData;
  }

  ThemeProvider() {
    setTheme();
  }

  ThemeData get themeData => _themeData;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void setTheme() {
    switch (MainData.selectedTheme) {
      case "Light":
        _themeData = AppTheme.lightMode;
        break;
      case "Dark":
        _themeData = AppTheme.darkMode;
        break;
      case "Pink":
        _themeData = AppTheme.pink;
      case "Rosy":
        _themeData = AppTheme.rosy;
        break;
      case "Cyan":
        _themeData = AppTheme.cyan;
        break;
      case "Halloween":
        _themeData = AppTheme.halloween;
        break;
      case "Rosso Corsa":
        _themeData = AppTheme.rossoCorsa;
        break;
      case "One":
        _themeData = AppTheme.one;
        break;
      case "Blueberry":
        _themeData = AppTheme.blueberry;
        break;
      case "Clover":
        _themeData = AppTheme.clover;
        break;
      default:
        _themeData = AppTheme.lightMode;
        break;
    }
    int index = availableThemes
        .indexWhere((theme) => theme.themename == MainData.selectedTheme);
    availableThemes[index].selected = true;
    notifyListeners();
  }

  void toggleTheme(ThemeData newTheme) {
    _themeData = newTheme;

    notifyListeners();
  }
}
