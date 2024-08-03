import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';


// Background Circal
class PositionedCircle extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

 PositionedCircle({
    super.key,
     this.top,
     this.left,
     this.right,
     this.bottom,
  });

  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          color: _themeColors.blueColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// App Icon Widget
class ChatBubble extends StatelessWidget {
 ChatBubble({super.key});
  final ThemeColors _themeColors = ThemeColors();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: _themeColors.blueColor,
          ),
          child: const Icon(
            CupertinoIcons.chat_bubble_fill,
            color: Colors.white,
            size: 50,
          ),
        ),
        Positioned(
          top: 28,
          left: 24.5,
          child: Text(
            "Link",
            style: TextStyle(
              color: _themeColors.blueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}


// main content container
class CustomContainer extends StatelessWidget {
  final Widget child;

  CustomContainer({super.key, required this.child});

  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: _themeColors.containerColor(context),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: _themeColors.boxShadow(context),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
            ],
          ),
        ),
      ),
    );
  }
}


// header text widget
class HeaderText extends StatelessWidget {
  final String text;

  const HeaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }
}


// For forgot password screens
class TitleText extends StatelessWidget {
  final String text;

  const TitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 35),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }
}


// sign up to login and login to sign up
class LinkPrompt extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onClick;

  const LinkPrompt({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = ThemeColors();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(promptText),
        TextButton(
          onPressed: onClick,
          child: Text(
            actionText,
            style: TextStyle(color: appTheme.blueColor),
          ),
        ),
      ],
    );
  }
}