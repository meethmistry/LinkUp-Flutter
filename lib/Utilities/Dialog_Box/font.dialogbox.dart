import 'package:flutter/material.dart';
import 'package:linkup/Providers/font.provider.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:provider/provider.dart';

class FontSizeOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  FontSizeOption({
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
          color: isSelected ? _themeColors.selectedContainerColor(context) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isSelected ? _themeColors.selectedTextColor(context) : _themeColors.changeTextColor(context),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}

class ChangeChatFontDialogBox extends StatefulWidget {
  const ChangeChatFontDialogBox({super.key});

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChangeChatFontDialogBox(),
    );
  }

  @override
  _ChangeChatFontDialogBoxState createState() => _ChangeChatFontDialogBoxState();
}

class _ChangeChatFontDialogBoxState extends State<ChangeChatFontDialogBox> {
  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    bool isSmall = fontSizeProvider.fontSize == 15;
    bool isMedium = fontSizeProvider.fontSize == 17.5;
    bool isLarge = fontSizeProvider.fontSize == 20;

    return AlertDialog(
      content: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Change Font",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FontSizeOption(
              label: "Small Font",
              onTap: () async {
                fontSizeProvider.setSmallFontSize();
                setState(() {});
                await Future.delayed(const Duration(milliseconds: 200));
                Navigator.of(context).pop();
              },
              isSelected: isSmall,
            ),
            FontSizeOption(
              label: "Medium Font",
              onTap: () async {
                fontSizeProvider.setMediumFontSize();
                setState(() {});
                await Future.delayed(const Duration(milliseconds: 200));
                Navigator.of(context).pop();
              },
              isSelected: isMedium,
            ),
            FontSizeOption(
              label: "Large Font",
              onTap: () async {
                fontSizeProvider.setLargeFontSize();
                setState(() {});
                await Future.delayed(const Duration(milliseconds: 200));
                Navigator.of(context).pop();
              },
              isSelected: isLarge,
            ),
          ],
        ),
      ],
    );
  }
}
