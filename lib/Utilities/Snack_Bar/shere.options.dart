import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class ShereOptions {
  final VoidCallback? onVideos;
  final VoidCallback? onCamera;
  final VoidCallback? onGallery;
  final VoidCallback? onAudio;
  final VoidCallback? onDocuments;
  final VoidCallback? onContact;

  ShereOptions({
    this.onVideos,
    this.onCamera,
    this.onGallery,
    this.onAudio,
    this.onDocuments,
    this.onContact,
  });

  final ThemeColors _themeColors = ThemeColors();

  void show(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: _themeColors.containerColor(context),
      padding: const EdgeInsets.symmetric(vertical: 25),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomIconButton(
                onTap: onVideos,
                text: 'Videos',
                icon: Icons.video_camera_back,
                containerColor: Colors.blueAccent,
                textColor: _themeColors.textColor(context),
              ),
              CustomIconButton(
                onTap: onCamera,
                text: 'Camera',
                icon: Icons.camera_alt,
                containerColor: Colors.purple,
                textColor: _themeColors.textColor(context),
              ),
              CustomIconButton(
                onTap: onGallery,
                text: 'Gallery',
                icon: Icons.photo,
                containerColor: Colors.lightGreen,
                textColor: _themeColors.textColor(context),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomIconButton(
                onTap: onAudio,
                text: 'Audio',
                icon: Icons.audiotrack,
                containerColor: Colors.redAccent,
                textColor: _themeColors.textColor(context),
              ),
              CustomIconButton(
                onTap: onDocuments,
                text: 'Documents',
                icon: Icons.insert_drive_file,
                containerColor: Colors.orange,
                textColor: _themeColors.textColor(context),
              ),
              CustomIconButton(
                onTap: onContact,
                text: 'Contact',
                icon: Icons.contacts,
                containerColor: Colors.pink,
                textColor: _themeColors.textColor(context),
              ),
            ],
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}



class CustomIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  final Color containerColor;
  final Color textColor;

  CustomIconButton({
    required this.onTap,
    required this.text,
    required this.icon,
    required this.containerColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: containerColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5), // Optional spacing between icon and text
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
