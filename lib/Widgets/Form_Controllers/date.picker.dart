import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class CustomDatePickerField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final VoidCallback onDateSelected;
  final bool isReadOnly;

  CustomDatePickerField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    required this.onDateSelected,
    this.isReadOnly = true,
  });

  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        cursorColor: _themeColors.blueColor,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: _themeColors.blueColor),
          prefixIcon: Icon(
            prefixIcon,
            color: _themeColors.blueColor,
          ),
          floatingLabelStyle: TextStyle(color: _themeColors.blueColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _themeColors.blueColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _themeColors.blueColor),
          ),
        ),
        onTap: onDateSelected,
      ),
    );
  }
}
