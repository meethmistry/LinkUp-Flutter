import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Settings/Widgets/main.settings.widget.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Dialog_Box/font.dialogbox.dart';
import 'package:linkup/Utilities/Dialog_Box/theme.dialogbox.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatSettings extends StatefulWidget {
  const ChatSettings({super.key});

  @override
  State<ChatSettings> createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: _themeColors.appBarForgroundColor(context),
        title: const Text(
          "Chats",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
      body: Column(
        children: [
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          const SizedBox(
            height: 10,
          ),
          CustomRowItem(
            leadingIcon: MdiIcons.themeLightDark,
            isMain: false,
            text: "Change Theme",
            onTap: () {
              const ChangeThemeDialogBox().show(context);
            },
          ),
          CustomRowItem(
            leadingIcon: MdiIcons.wallpaper,
            isMain: false,
            text: "Wallpaper",
            onTap: () {},
          ),
          CustomRowItem(
            leadingIcon: Icons.abc_outlined,
            isMain: false,
            text: "Change Font Size",
            onTap: () {
              const ChangeChatFontDialogBox().show(context);
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.delete_outline,
            isMain: false,
            text: "Delete All Chats",
            isDelete: true,
            onTap: () {
              CustomDialogBox(
                message: "Do you want to delete All Chats?",
                buttonOne: "No",
                buttonActionOne: () {
                  Navigator.of(context).pop();
                },
                buttonTwo: "Conform",
                buttonActionTwo: () {
                  Navigator.of(context).pop();
                  SuccessDialogBox(
                      message: "Your Chat is Deleted Successfully.",
                      buttonAction: () {
                        Navigator.of(context).pop();
                      }).show(context);
                },
              ).show(context);
            },
          ),
        ],
      ),
    );
  }
}
