// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:linkup/Authentications/Change%20Password%20Screens/get.user.email.dart';
import 'package:linkup/Authentications/signup.screen.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Main_Screens/chatlist.screen.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';
import 'package:linkup/Utilities/Snack_Bar/custom.snackbar.dart';
import 'package:linkup/Widgets/Backgrounds/design.widgets.dart';
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _themeColors = ThemeColors();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserFirebaseController _firebaseController = UserFirebaseController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      LoadingIndicator.show();

      try {
        String res = await _firebaseController.loginUsers(email, password);
        if (res == "Success") {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ChatListScreen();
            },
          ));
        } else {
          CustomSnackbar(
            text: 'Inccorect email or password.',
            color: _themeColors.snackBarRed(context),
          ).show(context);
        }
        LoadingIndicator.dismiss();
      } catch (e) {
        CustomSnackbar(
          text: 'Something want wrong',
          color: _themeColors.snackBarRed(context),
        ).show(context);
      }
    }
  }

  _forgotPassword() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const GetUserEmail();
      },
    ));
  }

  _signUp() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return SignUpScreen();
      },
    ));
  }

  _loginWithGoogle() {}

  Widget buildSocialLoginButton({
    required VoidCallback onTap,
    required Color color,
    Color? borderColor,
    required Widget icon,
    required String text,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width - 20,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
                    const HeaderText(text: "Welcome To Link Up"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              _forgotPassword();
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue),
                            )),
                      ],
                    ),
                    CustomButton(
                      buttonText: "Login",
                      onClick: _login,
                    ),
                    LinkPrompt(
                      actionText: "Sign Up",
                      onClick: _signUp,
                      promptText: "Don't have an account?",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                                color: _themeColors.iconColor(context),
                                height: 1.5),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _themeColors.iconColor(context),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                                color: _themeColors.iconColor(context),
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    buildSocialLoginButton(
                      onTap: () {
                        _loginWithGoogle();
                      },
                      color: Colors.white,
                      borderColor: Colors.black,
                      icon: Image.asset(
                        "assets/icons/google.png",
                        height: 30,
                        width: 30,
                      ),
                      text: 'Login With Google',
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
