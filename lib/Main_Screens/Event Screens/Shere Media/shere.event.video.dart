import 'dart:io'; // Add this import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/Controllers/event.message.controller.dart';
import 'package:linkup/Models/event.message.model.dart';
import 'package:video_player/video_player.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';

class ShareEventVideoPage extends StatefulWidget {
  final XFile? videoFile; // Change to XFile
  final String? eventId;
  final String? videoUrl;
  final String? senderName;
  final String? fileName;

  ShareEventVideoPage(
      {super.key,
      this.videoFile,
      this.eventId,
      this.videoUrl,
      this.senderName,
      this.fileName});

  @override
  _ShareVideoPageState createState() => _ShareVideoPageState();
}

class _ShareVideoPageState extends State<ShareEventVideoPage> {
  final EventMessageController _eventMessageController =
      EventMessageController();

  late VideoPlayerController _videoPlayerController;
  bool _isVideoInitialized = false;
  bool _isPlaying = true; // To keep track of playback state

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    if (widget.videoFile != null) {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.videoFile!.path));
    } else if (widget.videoUrl != null) {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl!);
    }

    _videoPlayerController.initialize().then((_) {
      setState(() {
        _isVideoInitialized = true;
        _videoPlayerController.play(); // Auto-play the video on load
      });
    });

    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _videoPlayerController.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _sendVideo() async {
    LoadingIndicator.show();
    final videoUrl = await _eventMessageController
        .uploadSharedVideoToStorage(widget.videoFile);
    if (videoUrl != null) {
      await _eventMessageController.sendEventMessage(
        eventId: widget.eventId!,
        senderId: FirebaseAuth.instance.currentUser!.uid,
        senderName: widget.senderName!,
        messageType: MessageTypeEvent.video,
        content: videoUrl,
        fileName: widget.fileName,
      );
      Navigator.pop(context);
    }
    LoadingIndicator.dismiss();
  }

  final ThemeColors _themeColors = ThemeColors();

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeColors.containerColor(context),
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: GestureDetector(
        onTap: _togglePlayPause,
        child: Stack(
          children: [
            Center(
              child: _isVideoInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                  : CircularProgressIndicator(),
            ),
            if (_isVideoInitialized)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    VideoProgressIndicator(
                      _videoPlayerController,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: _themeColors.blueColor,
                        bufferedColor: Colors.grey,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(
                              _videoPlayerController.value.position),
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _formatDuration(
                              _videoPlayerController.value.duration),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          onPressed: _sendVideo,
                          backgroundColor: _themeColors.blueColor,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 25,
                          ),
                          shape: CircleBorder(),
                          elevation: 6.0,
                          heroTag: null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
