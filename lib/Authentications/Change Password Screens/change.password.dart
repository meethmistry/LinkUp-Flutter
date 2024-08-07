// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/account.setting.screen.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Snack_Bar/custom.snackbar.dart';
import 'package:linkup/Widgets/Backgrounds/design.widgets.dart';
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final ThemeColors _themeColors = ThemeColors();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conformPasswordController =
      TextEditingController();

  _changePassword() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (_formKey.currentState!.validate()) {
      if (_conformPasswordController.text != _passwordController.text) {
        CustomSnackbar(
          text: 'Password and Confirm Password must be same',
          color: _themeColors.snackBarRed(context),
        ).show(context);
      } else {
        final old = _oldPasswordController.text;
        final password = _passwordController.text;
        final conformPassword = _conformPasswordController.text;
        SuccessDialogBox(
            message: "Your Password Is Changed Successfully.",
            buttonAction: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const AccountSettings();
                },
              ));
            }).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedCircle(
            top: -30,
            left: -150,
          ),
          PositionedCircle(
            top: 530,
            right: -150,
          ),
          Form(
              key: _formKey,
              child: CustomContainer(
                child: Column(
                  children: [
                    const HeaderText(text: "Change Password"),
                    CustomTextFormField(
                      controller: _oldPasswordController,
                      labelText: "Old Password",
                      prefixIcon: Icons.lock,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      controller: _passwordController,
                      labelText: "Password",
                      prefixIcon: Icons.lock,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      controller: _conformPasswordController,
                      labelText: "Conform Password",
                      prefixIcon: Icons.lock,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      buttonText: "Change Password",
                      onClick: _changePassword,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
