import 'package:flutter/material.dart';
import 'package:bai_system/core/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? lightMode : lightMode;
    notifyListeners();
  }
}
