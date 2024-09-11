import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Authentications/Change%20Password%20Screens/change.password.dart';
import 'package:linkup/Authentications/login.screen.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Main_Screens/user.profile.screen.dart';
import 'package:linkup/Settings/Widgets/main.settings.widget.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Snack_Bar/add.account.snackbar.dart';
import 'package:linkup/Utilities/Snack_Bar/custom.snackbar.dart';
import 'package:linkup/splash.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final ThemeColors _themeColors = ThemeColors();
  final UserFirebaseController _userFirebaseController =
      UserFirebaseController();
  _navigation(Widget _page) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return _page;
      },
    ));
  }

  _delete() async {
    LoadingIndicator.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _userFirebaseController.deleteAccount().whenComplete(() async {
        // Fetch the next account to log in
        List<String>? updatedAccountsList = prefs.getStringList('accounts');
        if (updatedAccountsList != null && updatedAccountsList.isNotEmpty) {
          // Pick the first account from the list (or any other logic to choose an account)
          String nextAccount = updatedAccountsList.first;
          Map<String, dynamic> userDetails = jsonDecode(nextAccount);

          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userDetails['email']!,
            password: userDetails['password']!,
          );

          // Set the new current account
          await prefs.setString('currentAccount', nextAccount);

          // Navigate to SplashScreen to reload the app with the new account
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            ),
          );
        } else {
          // If no other accounts are available, navigate to login screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return SplashScreen();
          },
        ));
      });
    } catch (e) {
      CustomSnackbar(
        text: 'Something want wrong.',
        color: _themeColors.snackBarRed(context),
      ).show(context);
    }
    LoadingIndicator.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: _themeColors.appBarForgroundColor(context),
        title: const Text(
          "Account",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
      body: Column(
        children: [
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          const SizedBox(
            height: 10,
          ),
          CustomRowItem(
            leadingIcon: CupertinoIcons.profile_circled,
            isMain: false,
            text: "Profile",
            onTap: () {
              _navigation(const UserProfileScreen());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.pin_outlined,
            isMain: false,
            text: "Change Password",
            onTap: () {
              CustomDialogBox(
                message: "Do you want to change password?",
                buttonOne: "No",
                buttonActionOne: () {
                  Navigator.of(context).pop();
                },
                buttonTwo: "Yes",
                buttonActionTwo: () {
                  Navigator.of(context).pop();
                  _navigation(ChangePassword());
                },
              ).show(context);
            },
          ),
          CustomRowItem(
            leadingIcon: CupertinoIcons.person_add,
            isMain: false,
            text: "Add New Account",
            onTap: () {
              AddNewAccount().show(context);
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.delete_outline,
            isMain: false,
            text: "Delete Account",
            isDelete: true,
            onTap: () {
              CustomDialogBox(
                message: "Do you want to delete your account?",
                buttonOne: "No",
                buttonActionOne: () {
                  Navigator.of(context).pop();
                },
                buttonTwo: "Conform",
                buttonActionTwo: () {
                  Navigator.of(context).pop();
                  SuccessDialogBox(
                      message: "Your Account is Deleted Successfully.",
                      buttonAction: () {
                        Navigator.of(context).pop();
                        _delete();
                      }).show(context);
                },
              ).show(context);
            },
          ),
        ],
      ),
    );
  }
}
