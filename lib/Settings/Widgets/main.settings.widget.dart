import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

// ignore: must_be_immutable
class CustomRowItem extends StatelessWidget {
  final IconData leadingIcon;
  final String text;
  final VoidCallback onTap;
  final bool isMain;
  bool isDelete;

  CustomRowItem({
    super.key,
    required this.leadingIcon,
    required this.text,
    required this.onTap,
    required this.isMain,
    this.isDelete = false,
  });

  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  leadingIcon,
                  size: 28,
                  color: isDelete ? Colors.red : _themeColors.iconColor(context),
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDelete ? Colors.red : _themeColors.textColor(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            if (isMain)
              Icon(
                Icons.arrow_forward_ios,
                size: 22,
                color: _themeColors.iconColor(context),
              ),
          ],
        ),
      ),
    );
  }
}
