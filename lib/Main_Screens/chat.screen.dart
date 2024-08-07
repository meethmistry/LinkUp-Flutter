import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Main_Screens/other.profile.screen.dart';
import 'package:linkup/Providers/font.provider.dart';
import 'package:linkup/Theme/app.theme.dart';

class UserChatScreen extends StatefulWidget {
  final Map<String, String> user;

  const UserChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _messageText = TextEditingController();
  final FontSizeProvider fontSizeProvider = FontSizeProvider();
  @override
  void initState() {
    super.initState();
    _messageText.addListener(_updateIcon);
  }

  @override
  void dispose() {
    _messageText.removeListener(_updateIcon);
    _messageText.dispose();
    super.dispose();
  }

  void _updateIcon() {
    setState(() {});
  }

  final ThemeColors _themeColors = ThemeColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeColors.blueColor,
        foregroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              Flexible(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.user['imageUrl']!),
                ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return OtherUserProfileScreen(
                  user: widget.user,
                );
              },
            ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user['name']!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                "last seen today at 14:00",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              CupertinoIcons.ellipsis_vertical,
            ),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return OtherUserProfileScreen(
                        user: widget.user,
                      );
                    },
                  ));
                  break;
                case 'call':
                  // Handle call action
                  break;
                case 'video':
                  // Handle video action
                  break;
                case 'share':
                  // Handle share action
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
                  value: 'call',
                  child: Row(
                    children: [
                      Icon(Icons.phone,
                          color: _themeColors.iconColor(context)),
                      const SizedBox(width: 8),
                      const Text('Call'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'video',
                  child: Row(
                    children: [
                      Icon(Icons.video_call,
                          color: _themeColors.iconColor(context)),
                      const SizedBox(width: 8),
                      const Text('Video Call'),
                    ],
                  ),
                ),
                 PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share,
                          color: _themeColors.iconColor(context)),
                      const SizedBox(width: 8),
                      const Text('Share'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              "Chat content goes here",
              style: TextStyle(fontSize: fontSizeProvider.fontSize),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.only(bottom: 3),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              height: 50,
              width: MediaQuery.sizeOf(context).width - 60,
              decoration: BoxDecoration(
                color: _themeColors.searchFilledColor(context),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 140,
                    child: TextField(
                      controller: _messageText,
                      autofocus: true,
                      cursorColor: _themeColors.blueColor,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: _themeColors.textColor(context),
                        ),
                        prefixIcon: const Icon(
                          Icons.message,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: _themeColors.textColor(context),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {},
                            child: const Icon(CupertinoIcons.paperclip)),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {},
                            child: const Icon(CupertinoIcons.camera)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _themeColors.blueColor,
              ),
              child: Icon(
                _messageText.text.isEmpty ? Icons.mic : Icons.send,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
