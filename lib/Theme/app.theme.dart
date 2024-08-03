import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class AppTheme {
  bool isDark(BuildContext context) {
    return AdaptiveTheme.of(context).mode.isDark;
  }
}

class ThemeColors {
  final AppTheme _appTheme = AppTheme();

  Color blueColor = const Color(0xFF3660D6);
  Color containerColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }

  Color iconColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.white : Colors.black;
  }

  Color textColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.white : Colors.black;
  }

  Color cameraIconColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }

  Color boxShadow(BuildContext context) {
    return _appTheme.isDark(context)
        ? Colors.grey.withOpacity(0.1)
        : Colors.grey.withOpacity(0.5);
  }

  Color snackBarGreen(BuildContext context) {
    return Colors.green;
  }

  Color snackBarRed(BuildContext context) {
    return Colors.red;
  }

  Color themeBasedIconColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }

  Color themeBasedTextColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }
}
