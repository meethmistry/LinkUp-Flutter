// ignore_for_file: avoid_init_to_null

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:linkup/Controllers/chat.controller.dart';
import 'package:linkup/Controllers/message.controller.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Main_Screens/Sub%20Screen%20For%20Shere/shere.document.dart';
import 'package:linkup/Main_Screens/Sub%20Screen%20For%20Shere/shere.image.dart';
import 'package:linkup/Main_Screens/Sub%20Screen%20For%20Shere/shere.video.dart';
import 'package:linkup/Main_Screens/other.profile.screen.dart';
import 'package:linkup/Models/message.model.dart';
import 'package:linkup/Models/user.model.dart';
import 'package:linkup/Providers/font.provider.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Snack_Bar/shere.options.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UserChatScreen extends StatefulWidget {
  final UserFirebase user;

  const UserChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _messageText = TextEditingController();
  final FontSizeProvider fontSizeProvider = FontSizeProvider();
  final ChatFirebaseController _chatFirebaseController =
      ChatFirebaseController();

  final MessageFirebaseController _messageFirebaseController =
      MessageFirebaseController();

  final UserFirebaseController _userFirebaseController =
      UserFirebaseController();

  @override
  void initState() {
    super.initState();
    _messageText.addListener(() {
      setState(() {
        _containerHeight = _calculateHeight();
      });
    });
    getOtherId();
    _messageText.addListener(_updateIcon);
  }

  late String otherUserId;
  late String? chatId;
  late List<MessageFirebase> messages = []; // Initialize with empty list
  final ScrollController _scrollController = ScrollController();
  getOtherId() async {
    otherUserId = widget.user.id!;
    chatId = await _chatFirebaseController.getChatIdForCurrentUser(otherUserId);
    if (chatId != null) {
      await getMessagesForThisChat(chatId!);
      // Scroll to the bottom after fetching messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  getMessagesForThisChat(String chatId) async {
    try {
      final fetchedMessages =
          await _messageFirebaseController.getMessagesByChatId(chatId);
      setState(() {
        messages = fetchedMessages;
      });
      // Scroll to the bottom after updating the messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print('Error retrieving messages: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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

  double _containerHeight = 50;
  double _calculateHeight() {
    final textHeight =
        _messageText.text.isEmpty ? 50.0 : _messageText.text.length * 2.0;
    return textHeight.clamp(50.0, 200.0); // Use double literals
  }

  final ThemeColors _themeColors = ThemeColors();

  // For images
  void _pickImage(ImageSource source) async {
    final imageBytes =
        await _messageFirebaseController.pickImageToShere(source);
    if (imageBytes != null) {
      // Extract file name
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShareImagePage(
            imageBytes: imageBytes,
            fileName: fileName, // Pass file name
            chatId: chatId!,
            otherUserId: otherUserId,
          ),
        ),
      ).whenComplete(() {
        getMessagesForThisChat(chatId!);
      });
    }
  }

// For videos
  void _pickVideo(ImageSource source) async {
    final videoFile = await _messageFirebaseController.pickVideoToShare(source);
    if (videoFile != null) {
      // Extract file name from the path
      final fileName =
          videoFile.name; // Use videoFile.name to get the file name

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShareVideoPage(
            videoFile: videoFile,
            fileName: fileName, // Pass file name
            chatId: chatId!,
            otherUserId: otherUserId,
          ),
        ),
      ).whenComplete(() {
        getMessagesForThisChat(chatId!);
      });
    }
  }

  var _document;
  var _fileName = null;
  bool isShow = false;
// Method to pick and share a document
  void _pickDocument() async {
    final documentFile = await _messageFirebaseController.pickDocumentToShare();
    if (documentFile != null) {
      // Extract file name from the document file
      final fileName = documentFile.name;

      _document = documentFile;
      _fileName = fileName;
      print(_fileName);
      if (_fileName != null) {
        setState(() {
          isShow = true;
        });
      }
    }
  }

  // Method to cancel the selected file
  void _cancelSelection() {
    setState(() {});
  }

// for show timestamp
  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('hh:mm a').format(dateTime);
  }

  bool isToday(String dateToCompare) {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('MMMM d, yyyy');
    String currentDate = formatter.format(now);
    return currentDate == dateToCompare;
  }

  bool isYesterday(String dateToCompare) {
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    DateFormat formatter = DateFormat('MMMM d, yyyy');
    String yesterdayDate = formatter.format(yesterday);
    return yesterdayDate == dateToCompare;
  }

  String _getFormattedDateHeader(DateTime timestamp) {
    DateFormat formatter = DateFormat('MMMM d, yyyy');
    String timeStamp = formatter.format(timestamp);
    if (isToday(timeStamp)) {
      return 'Today';
    } else if (isYesterday(timeStamp)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, yyyy').format(timestamp);
    }
  }

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
                  backgroundImage: widget.user.profileImageUrl != null
                      ? NetworkImage(widget.user.profileImageUrl!)
                      : const NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"),
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
                widget.user.userName!,
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
                      Icon(Icons.phone, color: _themeColors.iconColor(context)),
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
                      Icon(Icons.share, color: _themeColors.iconColor(context)),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final messageDate = DateFormat('yyyy-MM-dd')
                    .format(message.timestamp as DateTime);
                final previousMessageDate = index < messages.length - 1
                    ? DateFormat('yyyy-MM-dd')
                        .format(messages[index + 1].timestamp as DateTime)
                    : null;

                bool showDateHeader = messageDate != previousMessageDate;

                return Column(
                  crossAxisAlignment:
                      message.senderId == FirebaseAuth.instance.currentUser!.uid
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            _getFormattedDateHeader(message.timestamp!),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: message.senderId! ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 10, top: 8, bottom: 15),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.5,
                                      color: _themeColors.blueColor,
                                    ),
                                    borderRadius:
                                        message.messageType == MessageType.text
                                            ? BorderRadius.circular(25)
                                            : BorderRadius.circular(5),
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                    minWidth: 100,
                                  ),
                                  child: Builder(
                                    builder: (context) {
                                      Widget messageContent;

                                      switch (message.messageType) {
                                        case MessageType.text:
                                          // Display text
                                          messageContent = Text(
                                            message.content!,
                                            style: TextStyle(
                                                fontSize:
                                                    fontSizeProvider.fontSize),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          );
                                          break;

                                        case MessageType.image:
                                          // Display network image
                                          messageContent = InkWell(
                                            onTap: () {
                                              if (message.content != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShareImagePage(
                                                            imageUrl: message
                                                                .content),
                                                  ),
                                                ).whenComplete(() {
                                                  getMessagesForThisChat(
                                                      chatId!);
                                                });
                                              }
                                            },
                                            child: Image.network(
                                              message.content!,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                          break;

                                        case MessageType.video:
                                          messageContent = InkWell(
                                            onTap: () {
                                              if (message.content != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShareVideoPage(
                                                      videoUrl: message.content,
                                                    ),
                                                  ),
                                                ).whenComplete(() {
                                                  getMessagesForThisChat(
                                                      chatId!);
                                                });
                                              }
                                            },
                                            child: FutureBuilder<Widget>(
                                              future: _generateVideoThumbnail(
                                                  message.content!,
                                                  context), // Generate thumbnail
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  if (snapshot.hasData) {
                                                    return snapshot.data!;
                                                  } else {
                                                    return const Icon(Icons
                                                        .error); // Handle error case
                                                  }
                                                } else {
                                                  return const SizedBox
                                                      .shrink(); // Loading indicator
                                                }
                                              },
                                            ),
                                          );
                                          break;

                                        case MessageType.file:
                                          // Display text
                                          messageContent = InkWell(
                                            onTap: () {
                                              print(message.content!);
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return ShareDocumentPage(
                                                      docUrl: message.content!);
                                                },
                                              ));
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.insert_drive_file,
                                                  color: Colors.redAccent,
                                                  size: 40,
                                                ),
                                                const SizedBox(
                                                    width:
                                                        8), // Add some spacing between the icon and text
                                                Expanded(
                                                  child: Text(
                                                    message.fileName!,
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                    softWrap: true,

                                                    maxLines:
                                                        3, // Limit the text to 3 lines
                                                    overflow: TextOverflow
                                                        .ellipsis, // Add ellipsis for overflowing text
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          break;

                                        default:
                                          messageContent = Container();
                                      }

                                      return messageContent;
                                    },
                                  ),
                                ),
                                Positioned(
                                    bottom: 5,
                                    right: 18,
                                    child: Text(
                                      formatTimestamp(
                                          message.timestamp.toString()),
                                      style: const TextStyle(fontSize: 9),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: isShow ? 80 : 50,
          ),
        ],
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.only(bottom: 3),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isShow)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.only(right: 20),
                alignment: Alignment.center,
                height: _containerHeight,
                constraints: const BoxConstraints(
                  minHeight: 50,
                  maxHeight: 200,
                ),
                width: MediaQuery.sizeOf(context).width - 60,
                decoration: BoxDecoration(
                  color: _themeColors.searchFilledColor(context),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - 140,
                        child: TextField(
                          controller: _messageText,
                          autofocus: true,
                          minLines: 1,
                          maxLines: null,
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
                                onTap: () {
                                  ShereOptions(
                                    onVideos: () =>
                                        _pickVideo(ImageSource.gallery),
                                    onCamera: () =>
                                        _pickImage(ImageSource.camera),
                                    onGallery: () =>
                                        _pickImage(ImageSource.gallery),
                                    onAudio: () => print('Audio pressed'),
                                    onDocuments: () => _pickDocument(),
                                    onContact: () => print('Contact pressed'),
                                  ).show(context);
                                },
                                child: const Icon(CupertinoIcons.paperclip)),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  _pickImage(ImageSource.camera);
                                },
                                child: const Icon(CupertinoIcons.camera)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isShow)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                width: MediaQuery.sizeOf(context).width - 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.insert_drive_file,
                      color: Colors.redAccent,
                      size: 35,
                    ),
                    Text(_fileName)
                  ],
                ),
              ),
            InkWell(
              onTap: () async {
                if (_messageText.text.isNotEmpty) {
                  if (chatId != null) {
                    await _messageFirebaseController
                        .sendMessage(
                      chatId: chatId!,
                      receiverId: otherUserId,
                      messageType: MessageType.text,
                      content: _messageText.text,
                    )
                        .whenComplete(() {
                      setState(() {
                        _chatFirebaseController.updateChatLastMessage(
                            _messageText.text, chatId!);
                        _userFirebaseController.addChatId(chatId!, otherUserId);
                      });
                    });
                    _messageText.text = "";
                    getMessagesForThisChat(chatId!);
                  }
                } else if (isShow) {
                  final docUrl = await _messageFirebaseController
                      .uploadSharedDocumentToStorage(_document);
                  await _messageFirebaseController
                      .sendMessage(
                    chatId: chatId!,
                    receiverId: otherUserId,
                    messageType: MessageType.file,
                    content: docUrl!,
                    fileName: _fileName,
                  )
                      .whenComplete(() {
                    setState(() {
                      _chatFirebaseController.updateChatLastMessage(
                          "📃 Document", chatId!);
                      _userFirebaseController.addChatId(chatId!, otherUserId);
                    });
                  });
                  getMessagesForThisChat(chatId!);
                  setState(() {
                    isShow = false;
                    _document = null;
                    _fileName = null;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _themeColors.blueColor,
                ),
                child: Icon(
                  _messageText.text.isEmpty && !isShow ? Icons.mic : Icons.send,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Widget> _generateVideoThumbnail(
    String videoUrl, BuildContext context) async {
  try {
    final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail
      quality: 75,
    );

    if (thumbnail != null) {
      return Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width / 2,
          ),
          child: Image.memory(thumbnail, fit: BoxFit.cover));
    } else {
      // Return an error icon if thumbnail generation fails
      return const Icon(Icons.error, color: Colors.red);
    }
  } catch (e) {
    // Handle exceptions
    print('Error generating video thumbnail: $e');
    return const Icon(Icons.error, color: Colors.red);
  }
}
