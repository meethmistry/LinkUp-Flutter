import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Authentications/login.screen.dart';
import 'package:linkup/Main_Screens/user.profile.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/account.setting.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/call.history.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/chat.setting.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/notification.setting.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/privacy.setting.screen.dart';
import 'package:linkup/Settings/Widgets/main.settings.widget.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Snack_Bar/add.account.snackbar.dart';

class MainSettingScreen extends StatefulWidget {
  const MainSettingScreen({super.key});

  @override
  State<MainSettingScreen> createState() => _MainSettingScreenState();
}

class _MainSettingScreenState extends State<MainSettingScreen> {
  final ThemeColors _themeColors = ThemeColors();

  Uint8List? _image;

  _navigation(Widget _page) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return _page;
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: _themeColors.appBarForgroundColor(context),
        title: const Text(
          "Settings",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
      body: Column(
        children: [
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const UserProfileScreen();
                },
              ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"),
                        ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Deo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "johndeo123@gmail.com",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      AddNewAccount().show(context);
                    },
                    icon: Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: _themeColors.blueColor,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          const SizedBox(
            height: 20,
          ),
          CustomRowItem(
            leadingIcon: CupertinoIcons.profile_circled,
            isMain: true,
            text: "Account",
            onTap: () {
              _navigation(const AccountSettings());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.security,
            isMain: true,
            text: "Privacy",
            onTap: () {
              _navigation(const PrivacySetting());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.message_outlined,
            isMain: true,
            text: "Chats",
            onTap: () {
              _navigation(const ChatSettings());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.notifications,
            isMain: true,
            text: "Notifications",
            onTap: () {
              _navigation(NotificationSettings());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.history,
            isMain: true,
            text: "Call & Video Chat History",
            onTap: () {
              _navigation(CallOrVideoChatHistory());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.logout,
            isMain: true,
            text: "Logout",
            onTap: () {
              CustomDialogBox(
                message: "Do you want to logout?",
                buttonOne: "No",
                buttonActionOne: () {
                  Navigator.of(context).pop();
                },
                buttonTwo: "Yes",
                buttonActionTwo: () {
                  Navigator.of(context).pop();
                  _navigation(LoginScreen());
                },
              ).show(context);
            },
          ),
        ],
      ),
    );
  }
}
