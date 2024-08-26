import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:linkup/Controllers/chat.controller.dart';
import 'package:linkup/Controllers/message.controller.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Models/message.model.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';

class ShareImagePage extends StatefulWidget {
  final Uint8List? imageBytes;
  final String? chatId;
  final String? imageUrl;
  final String? otherUserId;

  ShareImagePage(
      {super.key,
      this.imageBytes,
      this.chatId,
      this.imageUrl,
      this.otherUserId});

  @override
  _ShareImagePageState createState() => _ShareImagePageState();
}

class _ShareImagePageState extends State<ShareImagePage> {
  final MessageFirebaseController _messageFirebaseController =
      MessageFirebaseController();

  final ChatFirebaseController _chatFirebaseController =
      ChatFirebaseController();
  final UserFirebaseController _userFirebaseController =
      UserFirebaseController();

  Future<void> _sendImage() async {
    LoadingIndicator.show();
    final imageUrl = await _messageFirebaseController
        .uploadSheredImageToStorage(widget.imageBytes);
    if (imageUrl != null) {
      await _messageFirebaseController
          .sendMessage(
        chatId: widget.chatId!,
        receiverId: widget.otherUserId!,
        messageType: MessageType.image,
        content: imageUrl,
      )
          .whenComplete(() {
        setState(() {
          _chatFirebaseController.updateChatLastMessage(
              "Image", widget.chatId!);
          _userFirebaseController.addChatId(
              widget.chatId!, widget.otherUserId!);
        });
      });
      Navigator.pop(context);
    }
    LoadingIndicator.dismiss();
  }

  Future<void> _sendToMultiusers() async {
    LoadingIndicator.show();
    final imageUrl = await _messageFirebaseController
        .uploadSheredImageToStorage(widget.imageBytes);
    if (imageUrl != null) {
      Navigator.pop(context);
    }
    LoadingIndicator.dismiss();
  }

  final ThemeColors _themeColors = ThemeColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeColors.containerColor(context),
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          Center(
            child: widget.imageBytes != null
                ? Image.memory(
                    widget.imageBytes!,
                    fit: BoxFit.cover,
                  )
                : widget.imageUrl != null
                    ? Image.network(
                        widget.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : SizedBox
                        .shrink(), // Placeholder if neither imageBytes nor imageUrl is provided
          ),
          if (widget.imageBytes != null)
            Positioned(
              bottom: 20, // Adjust the distance from the bottom if needed
              right: 20, // Adjust the distance from the right if needed
              child: FloatingActionButton(
                onPressed: _sendImage,
                backgroundColor: _themeColors.blueColor,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 25,
                ),
                shape: CircleBorder(),
                elevation: 6.0, // Optional: Add elevation if you want shadow
                heroTag:
                    null, // Optional: Add a unique tag if you have multiple FABs
              ),
            ),
        ],
      ),
    );
  }
}
