import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Main_Screens/chat.screen.dart';
import 'package:linkup/Main_Screens/search.screen.dart';
import 'package:linkup/Main_Screens/user.profile.screen.dart';
import 'package:linkup/Settings/main.setting.screen.dart';
import 'package:linkup/Theme/app.theme.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
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
  ];

  _navigation(Widget _page) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return _page;
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final statusUsers =
        users.where((user) => user["isStatus"] == "true").toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: _themeColors.appBarForgroundColor(context),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Link Up",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5),
            ),
            PopupMenuButton(
              icon: Icon(
                CupertinoIcons.ellipsis_vertical,
                color: _themeColors.iconColor(context),
              ),
              onSelected: (value) {
                switch (value) {
                  case 'profile':
                    _navigation(const UserProfileScreen());
                    break;
                  case 'search':
                    _navigation(const SearchScreen());
                    break;
                  case 'camera':
                    // Handle Camera action
                    break;
                  case 'settings':
                    _navigation(MainSettingScreen());
                    break;
                  case 'createGroup':
                    // Handle New Group
                    break;
                }
              },
              color: _themeColors.containerColor(context),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person_outline,
                            color: _themeColors.iconColor(context)),
                        const SizedBox(width: 8),
                        const Text('Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'createGroup',
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.person_2,
                            color: _themeColors.iconColor(context)),
                        const SizedBox(width: 8),
                        const Text('New Group'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'search',
                    child: Row(
                      children: [
                        Icon(Icons.search,
                            color: _themeColors.iconColor(context)),
                        const SizedBox(width: 8),
                        const Text('Search'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'camera',
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            color: _themeColors.iconColor(context)),
                        const SizedBox(width: 8),
                        const Text('Camera'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings_outlined,
                            color: _themeColors.iconColor(context)),
                        const SizedBox(width: 8),
                        const Text('Settings'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 7),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.grey,
                            foregroundColor: _themeColors.iconColor(context),
                          ),
                        ),
                        Positioned(
                          top: 45,
                          left: 63,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _themeColors.blueColor),
                              child: Icon(
                                Icons.add,
                                size: 15,
                                color:
                                    _themeColors.themeBasedIconColor(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Add Story"),
                    )
                  ],
                ),
                ...statusUsers.map((user) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(user["imageUrl"]!),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          user["name"]!.split(' ').first,
                          style: TextStyle(
                            color: _themeColors.textColor(context),
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Chats",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _themeColors.textColor(context)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserChatScreen(user: users[index]),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user["imageUrl"]!),
                    ),
                    title: Text(user["name"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user["lastMessage"]!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const SearchScreen();
            },
          ));
        },
        foregroundColor: Colors.white,
        splashColor: Colors.blueAccent,
        backgroundColor: _themeColors.blueColor,
        child: const Icon(
          Icons.search,
          size: 28,
        ),
      ),
    );
  }
}
