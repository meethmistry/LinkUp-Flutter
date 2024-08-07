import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String _currentTheme = 'Default'; // Default theme

  String get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentTheme = prefs.getString('currentTheme') ?? 'Default';
    notifyListeners();
  }

  void _saveTheme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentTheme', theme);
  }

  void setDefaultTheme() {
    _currentTheme = 'Default';
    _saveTheme(_currentTheme);
    notifyListeners();
  }

  void setLightTheme() {
    _currentTheme = 'Light Mode';
    _saveTheme(_currentTheme);
    notifyListeners();
  }

  void setDarkTheme() {
    _currentTheme = 'Dark Mode';
    _saveTheme(_currentTheme);
    notifyListeners();
  }
}
