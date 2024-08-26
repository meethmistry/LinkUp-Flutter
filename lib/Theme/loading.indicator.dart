import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:linkup/Theme/app.theme.dart';

class LoadingIndicator {
  static void show() {
    EasyLoading.show(
      indicator: CircularProgressIndicator(
        color: ThemeColors().blueColor,
        backgroundColor: Colors.white,
      ),
      status: "Loading...",
    );
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}

class LoadingIndicatorSent {
  static void show({required String status}) {
    EasyLoading.show(
      indicator: CircularProgressIndicator(
        color: ThemeColors().blueColor,
        backgroundColor: Colors.white,
      ),
      status: status,
    );
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}

