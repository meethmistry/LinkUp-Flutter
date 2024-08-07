import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Authentications/Change%20Password%20Screens/change.password.dart';
import 'package:linkup/Authentications/signup.screen.dart';
import 'package:linkup/Main_Screens/user.profile.screen.dart';
import 'package:linkup/Settings/Widgets/main.settings.widget.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Snack_Bar/add.account.snackbar.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final ThemeColors _themeColors = ThemeColors();
  _navigation(Widget _page) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return _page;
      },
    ));
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
                        _navigation(const SignUpScreen());
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
