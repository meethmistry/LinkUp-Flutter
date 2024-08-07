import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Settings/Widgets/main.settings.widget.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Dialog_Box/user.settings.dialogbox.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PrivacySetting extends StatefulWidget {
  const PrivacySetting({super.key});

  @override
  State<PrivacySetting> createState() => _PrivacySettingState();
}

class _PrivacySettingState extends State<PrivacySetting> {
  final ThemeColors _themeColors = ThemeColors();

   final List<Map<String, String>> users = [
    {
      "name": "User One",
      "lastMessage": "This is Last Message",
      "email": "userone12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"
    },
    {
      "name": "User Two",
      "lastMessage": "This is Last Message",
      "email": "usertwo12@gmail.com",
      "isStatus": "false",
      "imageUrl":
          "https://www.shutterstock.com/image-vector/default-user-profile-icon-vector-260nw-2422228925.jpg"
    },
    {
      "name": "User Three",
      "lastMessage": "This is Last Message",
      "email": "userthree12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://w7.pngwing.com/pngs/867/694/png-transparent-user-profile-default-computer-icons-network-video-recorder-avatar-cartoon-maker-blue-text-logo.png"
    },
    {
      "name": "User One",
      "lastMessage": "This is Last Message",
      "email": "userone12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"
    },
    {
      "name": "User Two",
      "lastMessage": "This is Last Message",
      "email": "usertwo12@gmail.com",
      "isStatus": "false",
      "imageUrl":
          "https://www.shutterstock.com/image-vector/default-user-profile-icon-vector-260nw-2422228925.jpg"
    },
    {
      "name": "User Three",
      "lastMessage": "This is Last Message",
      "email": "userthree12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://w7.pngwing.com/pngs/867/694/png-transparent-user-profile-default-computer-icons-network-video-recorder-avatar-cartoon-maker-blue-text-logo.png"
    },{
      "name": "User One",
      "lastMessage": "This is Last Message",
      "email": "userone12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"
    },
    {
      "name": "User Two",
      "lastMessage": "This is Last Message",
      "email": "usertwo12@gmail.com",
      "isStatus": "false",
      "imageUrl":
          "https://www.shutterstock.com/image-vector/default-user-profile-icon-vector-260nw-2422228925.jpg"
    },
    {
      "name": "User Three",
      "lastMessage": "This is Last Message",
      "email": "userthree12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://w7.pngwing.com/pngs/867/694/png-transparent-user-profile-default-computer-icons-network-video-recorder-avatar-cartoon-maker-blue-text-logo.png"
    },{
      "name": "User One",
      "lastMessage": "This is Last Message",
      "email": "userone12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"
    },
    {
      "name": "User Two",
      "lastMessage": "This is Last Message",
      "email": "usertwo12@gmail.com",
      "isStatus": "false",
      "imageUrl":
          "https://www.shutterstock.com/image-vector/default-user-profile-icon-vector-260nw-2422228925.jpg"
    },
    {
      "name": "User Three",
      "lastMessage": "This is Last Message",
      "email": "userthree12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://w7.pngwing.com/pngs/867/694/png-transparent-user-profile-default-computer-icons-network-video-recorder-avatar-cartoon-maker-blue-text-logo.png"
    },{
      "name": "User One",
      "lastMessage": "This is Last Message",
      "email": "userone12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"
    },
    {
      "name": "User Two",
      "lastMessage": "This is Last Message",
      "email": "usertwo12@gmail.com",
      "isStatus": "false",
      "imageUrl":
          "https://www.shutterstock.com/image-vector/default-user-profile-icon-vector-260nw-2422228925.jpg"
    },
    {
      "name": "User Three",
      "lastMessage": "This is Last Message",
      "email": "userthree12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://w7.pngwing.com/pngs/867/694/png-transparent-user-profile-default-computer-icons-network-video-recorder-avatar-cartoon-maker-blue-text-logo.png"
    },{
      "name": "User One",
      "lastMessage": "This is Last Message",
      "email": "userone12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"
    },
    {
      "name": "User Two",
      "lastMessage": "This is Last Message",
      "email": "usertwo12@gmail.com",
      "isStatus": "false",
      "imageUrl":
          "https://www.shutterstock.com/image-vector/default-user-profile-icon-vector-260nw-2422228925.jpg"
    },
    {
      "name": "User Three",
      "lastMessage": "This is Last Message",
      "email": "userthree12@gmail.com",
      "isStatus": "true",
      "imageUrl":
          "https://w7.pngwing.com/pngs/867/694/png-transparent-user-profile-default-computer-icons-network-video-recorder-avatar-cartoon-maker-blue-text-logo.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: _themeColors.appBarForgroundColor(context),
        title: const Text(
          "Privacy",
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
            leadingIcon: Icons.adjust_outlined,
            isMain: false,
            text: "Hide Status",
            onTap: () {
              SettingsDialogBox(users: users).show(context);
            },
          ),
          CustomRowItem(
            leadingIcon: CupertinoIcons.eye_slash,
            isMain: false,
            text: "Hide Last Seen",
            onTap: () {
              SettingsDialogBox(users: users).show(context);
            },
          ),
          CustomRowItem(
            leadingIcon: MdiIcons.imageLockOutline,
            isMain: false,
            text: "Hide Profile Image",
            onTap: () {
              SettingsDialogBox(users: users).show(context);
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.block_outlined,
            isMain: false,
            text: "Blocked",
            onTap: () {
              SettingsDialogBox().show(context);
            },
          ),
        ],
      ),
    );
  }
}
