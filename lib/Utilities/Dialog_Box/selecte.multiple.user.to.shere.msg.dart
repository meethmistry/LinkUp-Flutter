import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:linkup/Controllers/chat.controller.dart';
import 'package:linkup/Controllers/message.controller.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Models/message.model.dart';
import 'package:linkup/Models/user.model.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';

class SendMessageToMultipleUser extends StatefulWidget {
  final List<UserFirebase>? users;
  final Uint8List imageBytes;

  SendMessageToMultipleUser({this.users, required this.imageBytes});

  @override
  _SettingsDialogBoxState createState() => _SettingsDialogBoxState();

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }
}

class _SettingsDialogBoxState extends State<SendMessageToMultipleUser> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late List<UserFirebase> _filteredUsers;
  final ThemeColors _themeColors = ThemeColors();
  final ChatFirebaseController _chatFirebaseController =
      ChatFirebaseController();
  final MessageFirebaseController _messageFirebaseController =
      MessageFirebaseController();
  final UserFirebaseController _userFirebaseController =
      UserFirebaseController();

  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.users ?? [];
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      _filteredUsers = widget.users
              ?.where((user) => user.userName!
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList() ??
          [];
    });
  }

  List<String> receiverId = [];

  _sendImage() async {
    LoadingIndicatorSent.show(status: "Sending...");
    for (var id in receiverId) {
      String? chatId =
          await _chatFirebaseController.getChatIdForCurrentUser(id);
      print(chatId);
      if (chatId != null) {
        final imageUrl = await _messageFirebaseController
            .uploadSheredImageToStorage(widget.imageBytes);
        await _messageFirebaseController
            .sendMessage(
          chatId: chatId,
          receiverId: id,
          messageType: MessageType.image,
          content: imageUrl!,
        ).whenComplete(() {
          setState(() {
            _chatFirebaseController.updateChatLastMessage("📷 Image", chatId);
            _userFirebaseController.addChatId(chatId, id);
          });
        });
      }
    }
    LoadingIndicatorSent.dismiss();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _themeColors.containerColor(context),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      content: SizedBox(
        height: MediaQuery.sizeOf(context).height / 2,
        width: MediaQuery.sizeOf(context).width - 15,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              cursorColor: _themeColors.blueColor,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: _themeColors.blueColor),
                labelText: 'Search',
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _themeColors.blueColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _themeColors.blueColor),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profileImageUrl!),
                    ),
                    title: Text(user.userName!),
                    trailing: Checkbox(
                      value: receiverId.contains(user.id),
                      activeColor: _themeColors.blueColor,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            if (!receiverId.contains(user.id)) {
                              receiverId.add(user.id!);
                            }
                          } else if (value == false) {
                            if (receiverId.contains(user.id)) {
                              receiverId.remove(user.id!);
                            }
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: _themeColors.blueColor),
          ),
        ),
        TextButton(
          onPressed: () {
            _sendImage();
          },
          child: Text(
            'Send',
            style: TextStyle(color: _themeColors.blueColor),
          ),
        ),
      ],
    );
  }
}
