// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:linkup/Main_Screens/chatlist.screen.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Snack_Bar/custom.snackbar.dart';
import 'package:linkup/Widgets/Backgrounds/design.widgets.dart';
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _GetUserEmailState();
}

class _GetUserEmailState extends State<SetNewPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conformPasswordController =
      TextEditingController();
  final ThemeColors _themeColors = ThemeColors();
  _setNewPassword() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (_formKey.currentState!.validate()) {
      if (_conformPasswordController.text != _passwordController.text) {
        CustomSnackbar(
          text: 'Password and Confirm Password must be same',
          color: _themeColors.snackBarRed(context),
        ).show(context);
      } else {
        final password = _passwordController.text;
        final conformPassword = _conformPasswordController.text;
         Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return ChatListScreen();
        },
      ));
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
                    const HeaderText(text: "Enter New Password"),
                    const TitleText(
                      text: "Please enter your new password and confirm it.",
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
                      buttonText: "Set Password",
                      onClick: _setNewPassword,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
