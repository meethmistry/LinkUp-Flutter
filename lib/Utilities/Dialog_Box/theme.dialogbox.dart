import 'package:flutter/material.dart';
import 'package:linkup/Providers/theme.provider.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:provider/provider.dart';

class ThemeOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  ThemeOption({
    required this.label,
    required this.onTap,
    required this.isSelected,
    super.key,
  });
  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? _themeColors.selectedContainerColor(context)
              : null, // Adjust according to your theme colors
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isSelected
                    ? _themeColors.selectedTextColor(context)
                    : _themeColors.changeTextColor(
                        context), // Adjust according to your theme colors
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}

class ChangeThemeDialogBox extends StatefulWidget {
  const ChangeThemeDialogBox({super.key});

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChangeThemeDialogBox(),
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _ChangeThemeDialogBoxState createState() => _ChangeThemeDialogBoxState();
}

class _ChangeThemeDialogBoxState extends State<ChangeThemeDialogBox> {
  final AppTheme _appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDefault = themeProvider.currentTheme == 'Default';
    bool isLight = themeProvider.currentTheme == 'Light Mode';
    bool isDark = themeProvider.currentTheme == 'Dark Mode';
    return AlertDialog(
      content: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Change Theme",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThemeOption(
              label: "Default Theme",
              onTap: () async {
                themeProvider.setDefaultTheme();
                setState(() {
                  _appTheme.changeTheme(context, false);
                });
                await Future.delayed(const Duration(milliseconds: 200));
                Navigator.of(context).pop();
              },
              isSelected: isDefault,
            ),
            ThemeOption(
              label: "Light Theme",
              onTap: () async {
                themeProvider.setLightTheme();
                setState(() {
                  _appTheme.changeTheme(context, false);
                });
                await Future.delayed(const Duration(milliseconds: 200));
                Navigator.of(context).pop();
              },
              isSelected: isLight,
            ),
            ThemeOption(
              label: "Dark Theme",
              onTap: () async {
                themeProvider.setDarkTheme();
                setState(() {
                  _appTheme.changeTheme(context, true);
                });
                await Future.delayed(const Duration(milliseconds: 200));
                Navigator.of(context).pop();
              },
              isSelected: isDark,
            ),
          ],
        ),
      ],
    );
  }
}
