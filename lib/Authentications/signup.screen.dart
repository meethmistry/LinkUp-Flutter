// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:linkup/Authentications/Buied_User_Profile/user.profile.details.dart';
import 'package:linkup/Authentications/login.screen.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Snack_Bar/custom.snackbar.dart';
import 'package:linkup/Widgets/Backgrounds/design.widgets.dart';
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final ThemeColors _themeColors = ThemeColors();

  _login() {
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const LoginScreen();
      },
    ));
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conformPasswordController =
      TextEditingController();

  _signUp() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (_formKey.currentState!.validate()) {
      if (_conformPasswordController.text != _passwordController.text) {
        CustomSnackbar(
          text: 'Password and Confirm Password must be same',
          color: _themeColors.snackBarRed(context),
        ).show(context);
      } else {
        final email = _emailController.text;
        final password = _passwordController.text;
        final conformPassword = _conformPasswordController.text;
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const BuiledUserProfile();
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
                    ChatBubble(),
                    const HeaderText(text: "Create New Account"),
                    CustomTextFormField(
                      controller: _emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      pattern: r'^[^@]+@[^@]+\.[^@]+$',
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
                      buttonText: "Sign Up",
                      onClick: _signUp,
                    ),
                    LinkPrompt(
                      actionText: "Login",
                      onClick: _login,
                      promptText: "Already have an account?",
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
