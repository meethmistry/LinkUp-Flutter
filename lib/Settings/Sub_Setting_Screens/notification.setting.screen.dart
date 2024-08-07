import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Settings/Widgets/main.settings.widget.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Dialog_Box/user.settings.dialogbox.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
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
    },
  ];

  bool _notification = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: _themeColors.appBarForgroundColor(context),
        title: const Text(
          "Notification",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
      body: Column(
        children: [
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                     fontSize: 20,
                      color: _themeColors.textColor(context),
                      fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: _notification,
                  onChanged: (bool value) {
                    setState(() {
                      _notification = value;
                    });
                  },
                  activeColor:
                      _themeColors.blueColor, // Customize active switch color
                ),
              ],
            ),
          ),
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          CustomRowItem(
            leadingIcon: Icons.notifications_off_outlined,
            isMain: false,
            text: "Mute Notifications",
            onTap: () {
              SettingsDialogBox(users: users).show(context);
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.notifications_off_outlined,
            isMain: false,
            text: "Mute Group Notifications",
            onTap: () {
              SettingsDialogBox(users: users).show(context);
            },
          ),
        ],
      ),
    );
  }
}
