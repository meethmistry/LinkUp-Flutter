// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/account.setting.screen.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';
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

  _changePassword() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (_formKey.currentState!.validate()) {
      if (_conformPasswordController.text != _passwordController.text) {
        CustomSnackbar(
          text: 'Password and Confirm Password must be same',
          color: _themeColors.snackBarRed(context),
        ).show(context);
      } else if (_passwordController.text.length < 6) {
        CustomSnackbar(
          text: 'Password length should be greter then 5.',
          color: _themeColors.snackBarRed(context),
        ).show(context);
      } else {
        LoadingIndicator.show();
        final old = _oldPasswordController.text;
        final password = _passwordController.text;
        final conformPassword = _conformPasswordController.text;
        try {
          User? user = FirebaseAuth.instance.currentUser;
          String email = user!.email!;

          AuthCredential credential = EmailAuthProvider.credential(
            email: email,
            password: old,
          );

          await user.reauthenticateWithCredential(credential);

          await user.updatePassword(password);

          await Future.delayed(Duration(seconds: 2));
          LoadingIndicator.dismiss();

          SuccessDialogBox(
            message: "Your Password Is Changed Successfully.",
            buttonAction: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettings(),
                ),
              );
            },
          ).show(context);
        } catch (error) {
          LoadingIndicator.dismiss();

          CustomSnackbar(
            text: 'Failed to change password. Please try again.',
            color: _themeColors.snackBarRed(context),
          ).show(context);
        }
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
