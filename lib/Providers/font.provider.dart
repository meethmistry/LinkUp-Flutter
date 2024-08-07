import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeProvider with ChangeNotifier {
  double _fontSize = 17.5; // default font size

  double get fontSize => _fontSize;

  FontSizeProvider() {
    _loadFontSize();
  }

  void _loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? 17.5;
    notifyListeners();
  }

  void _saveFontSize(double size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
  }

  void setSmallFontSize() {
    _fontSize = 15;
    _saveFontSize(_fontSize);
    notifyListeners();
  }

  void setMediumFontSize() {
    _fontSize = 17.5;
    _saveFontSize(_fontSize);
    notifyListeners();
  }

  void setLargeFontSize() {
    _fontSize = 20.0;
    _saveFontSize(_fontSize);
    notifyListeners();
  }
}
