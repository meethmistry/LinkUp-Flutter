import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Controllers/event.message.controller.dart';
import 'package:linkup/Models/event.message.model.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';

class ShareEventImagePage extends StatefulWidget {
  final Uint8List? imageBytes;
  final String? eventId;
  final String? imageUrl;
  final String? senderName;
  final String? fileName;

  ShareEventImagePage(
      {super.key,
      this.imageBytes,
      this.eventId,
      this.imageUrl,
      this.senderName,
      this.fileName});

  @override
  _ShareImagePageState createState() => _ShareImagePageState();
}

class _ShareImagePageState extends State<ShareEventImagePage> {
  final EventMessageController _eventMessageController =
      EventMessageController();

  Future<void> _sendImage() async {
    LoadingIndicator.show();
    final imageUrl = await _eventMessageController
        .uploadSheredImageToStorage(widget.imageBytes);
    if (imageUrl != null) {
      await _eventMessageController.sendEventMessage(
        eventId: widget.eventId!,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        senderName: widget.senderName!,
        messageType: MessageTypeEvent.image,
        content: imageUrl,
        fileName: widget.fileName,
      );
      Navigator.pop(context);
    }
    LoadingIndicator.dismiss();
  }

  // Future<void> _sendToMultiusers() async {
  //   LoadingIndicator.show();
  //   final imageUrl = await _messageFirebaseController
  //       .uploadSheredImageToStorage(widget.imageBytes);
  //   if (imageUrl != null) {
  //     Navigator.pop(context);
  //   }
  //   LoadingIndicator.dismiss();
  // }

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
