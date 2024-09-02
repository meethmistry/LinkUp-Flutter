import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class AppTheme {
  bool isDark(BuildContext context) {
    return AdaptiveTheme.of(context).mode.isDark;
  }

  void changeTheme(BuildContext context, bool isDark) {
    if (isDark) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
  }
}

class ThemeColors {
  final AppTheme _appTheme = AppTheme();

  Color blueColor = const Color(0xFF3660D6);
  Color containerColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }

  Color iconColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.white : Colors.black;
  }

  Color textColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.white : Colors.black;
  }

  Color cameraIconColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }

  Color boxShadow(BuildContext context) {
    return _appTheme.isDark(context)
        ? Colors.grey.withOpacity(0.1)
        : Colors.grey.withOpacity(0.5);
  }

  Color snackBarGreen(BuildContext context) {
    return Colors.green;
  }

  Color snackBarRed(BuildContext context) {
    return Colors.red;
  }

  Color themeBasedIconColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }

  Color themeBasedTextColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }

  Color appBarBackgroundColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }

  Color appBarForgroundColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.white : blueColor;
  }

  Color? searchFilledColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.grey[800] : Colors.grey[300];
  }

  Color changeTextColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.white : Colors.black;
  }

  Color selectedTextColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.black : Colors.white;
  }

  Color selectedContainerColor(BuildContext context) {
    return _appTheme.isDark(context) ? Colors.white : blueColor;
  }
}

class ChangeTheme extends StatelessWidget {
  ChangeTheme({
    super.key,
  });
  final AppTheme _appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_appTheme.isDark(context)) {
          _appTheme.changeTheme(context, false);
          AdaptiveTheme.of(context).setLight();
        } else {
          
          _appTheme.changeTheme(context, true);
          AdaptiveTheme.of(context).setDark();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 31,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(
              color: _appTheme.isDark(context) ? Colors.white : Colors.black,
              width: 1.5),
          borderRadius: BorderRadius.circular(15),
          // color: _appTheme.isDark(context) ? Colors.grey : Colors.white,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: _appTheme.isDark(context) ? 20.0 : 0.0,
              right: _appTheme.isDark(context) ? 0.0 : 20.0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _appTheme.isDark(context)
                    ? Container(
                        padding: const EdgeInsets.all(2.5),
                        child: const Icon(
                          Icons.light_mode,
                          key: ValueKey('light'),
                          size: 22,
                          color: Colors.white,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(2.5),
                        child: const Icon(
                          Icons.dark_mode,
                          key: ValueKey('dark'),
                          size: 23,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
