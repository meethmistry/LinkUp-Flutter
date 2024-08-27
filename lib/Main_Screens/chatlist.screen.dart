import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/Controllers/message.controller.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Main_Screens/chat.screen.dart';
import 'package:linkup/Main_Screens/search.screen.dart';
import 'package:linkup/Main_Screens/user.profile.screen.dart';
import 'package:linkup/Models/user.model.dart';
import 'package:linkup/Settings/main.setting.screen.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Dialog_Box/selecte.multiple.user.to.shere.msg.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ThemeColors _themeColors = ThemeColors();
  final UserFirebaseController _userFirebaseController =
      UserFirebaseController();

  final MessageFirebaseController _messageFirebaseController =
      MessageFirebaseController();

  _navigation(Widget _page) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return _page;
      },
    )).whenComplete(() {
      setState(() {
        if (_page == SearchScreen()) {
          getUsers();
        }
      });
    });
  }

  List<UserWithMessage> usersWithMessages = [];
  List<UserFirebase> users = [];
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    try {
      List<UserWithMessage> fetchedUsers =
          await _userFirebaseController.getChatUsers();
      users = await _userFirebaseController.getChatUsersForMultipalShere();
      setState(() {
        usersWithMessages = fetchedUsers;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void _pickImage(ImageSource source) async {
    final imageBytes =
        await _messageFirebaseController.pickImageToShere(source);
    if (imageBytes != null) {
      SendMessageToMultipleUser(
        users: users,
        imageBytes: imageBytes,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    _pickImage(ImageSource.camera);
                    break;
                  case 'settings':
                    _navigation(const MainSettingScreen());
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
          Expanded(
            child: ListView.builder(
              itemCount: usersWithMessages.length,
              itemBuilder: (context, index) {
                final usersWithMsg = usersWithMessages[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserChatScreen(user: usersWithMsg.user),
                      ),
                    ).whenComplete(() {
                      setState(() {
                        getUsers();
                      });
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: usersWithMsg.user.profileImageUrl != null
                          ? NetworkImage(usersWithMsg.user.profileImageUrl!)
                          : const NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"),
                    ),
                    title: Text(usersWithMsg.user.userName ?? 'Unknown User',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      usersWithMsg.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow
                          .ellipsis, // This will hide remaining text
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const SearchScreen();
            },
          )).whenComplete(() {
            setState(() {
              getUsers();
            });
          });
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
