import 'package:flutter/cupertino.dart';
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
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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

class SuccessDialogBox {
  final String message;
  final VoidCallback buttonAction;

  SuccessDialogBox({
    required this.message,
    required this.buttonAction,
  });

  final ThemeColors _themeColors = ThemeColors();

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _themeColors.containerColor(context),
          content: Container(
            alignment: Alignment.center,
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _themeColors.textColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green
                  ),
                  child: const Icon(Icons.check, size: 45, color: Colors.white,)),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: buttonAction,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    decoration: BoxDecoration(
                      color: _themeColors.blueColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Text(
                      "ok",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
