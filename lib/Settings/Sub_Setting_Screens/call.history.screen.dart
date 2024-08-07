import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class CallOrVideoChatHistory extends StatefulWidget {
  const CallOrVideoChatHistory({super.key});

  @override
  State<CallOrVideoChatHistory> createState() => _CallOrVideoChatHistoryState();
}

class _CallOrVideoChatHistoryState extends State<CallOrVideoChatHistory> {
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: _themeColors.appBarForgroundColor(context),
        title: const Text(
          "Call & Video Chat History",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
      body: Column(
        children: [
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user["imageUrl"]!),
                  ),
                  title: Text(user["name"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(user["lastMessage"]!),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: user['isStatus']!.contains("true")
                          ? const Icon(Icons.phone)
                          : const Icon(Icons.video_call)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
