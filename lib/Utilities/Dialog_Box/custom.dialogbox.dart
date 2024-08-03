import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class CustomDialogBox {
  final String message;
  final String buttonOne;
  final VoidCallback buttonActionOne;
  final String buttonTwo;
  final VoidCallback buttonActionTwo;

  CustomDialogBox({
    required this.message,
    required this.buttonOne,
    required this.buttonActionOne,
    required this.buttonTwo,
    required this.buttonActionTwo,
  });

  final ThemeColors _themeColors = ThemeColors();

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          content: Text(
            message,
            style: TextStyle(color: _themeColors.textColor(context)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: buttonActionOne,
              child: Text(
                buttonOne,
                style: TextStyle(color: _themeColors.blueColor),
              ),
            ),
            TextButton(
              onPressed: buttonActionTwo,
              child: Text(
                buttonTwo,
                style: TextStyle(color: _themeColors.blueColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
