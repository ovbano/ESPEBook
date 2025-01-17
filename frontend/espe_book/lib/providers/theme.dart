import 'package:flutter/material.dart';
import 'package:espe_book/models/theme_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreference themePreference = ThemePreference();
  String _theme = ThemePreference.LIGHT;

  String get theme => _theme;

  get mode => null;

  set setTheme (String theme) {
    _theme = theme;
    notifyListeners();
  }

  toggleTheme() {}

  getTheme() {}
}