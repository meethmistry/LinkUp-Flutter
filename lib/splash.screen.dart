import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Main_Screens/chatlist.screen.dart';
import 'package:linkup/Theme/app.theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ThemeColors _themeColors = ThemeColors();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatListScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Color? whiteThemeColor = AdaptiveTheme.of(context).mode.isLight
        ? _themeColors.blueColor
        : Colors.white;

    bool isDark = AdaptiveTheme.of(context).mode.isDark;

    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            if (isDark) {
              AdaptiveTheme.of(context).setLight();
            } else {
              AdaptiveTheme.of(context).setDark();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Spacer(flex: 4),
              LogoWidget(themeColors: _themeColors),
              const Spacer(flex: 3),
              TextWidget(whiteThemeColor: whiteThemeColor),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  final ThemeColors themeColors;

  const LogoWidget({required this.themeColors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: themeColors.blueColor,
          ),
          child: const Icon(
            CupertinoIcons.chat_bubble_fill,
            color: Colors.white,
            size: 50,
          ),
        ),
        Positioned(
          top: 29,
          child: Text(
            "Link",
            style: TextStyle(
              fontSize: 12,
              color: themeColors.blueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class TextWidget extends StatelessWidget {
  final Color? whiteThemeColor;

  const TextWidget({required this.whiteThemeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.chat_bubble_text_fill,
          size: 25,
          color: whiteThemeColor,
        ),
        const SizedBox(width: 8),
        Text(
          "Link Up",
          style: TextStyle(
            color: whiteThemeColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
