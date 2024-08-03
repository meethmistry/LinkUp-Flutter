import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class GalleryOrCamera {
  GalleryOrCamera();
  final ThemeColors _themeColors = ThemeColors();
  void show(BuildContext context, VoidCallback selectGalleryImage, VoidCallback selectCameraImage, VoidCallback removeImage) {
    var snackBar = SnackBar(
      content: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Remove Image",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: _themeColors.textColor(context)),
                ),
                IconButton(onPressed: removeImage, icon: const Icon(Icons.delete))
              ],
            ),
            const SizedBox(
              height: 13,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 15,
                ),
                OptionsForProfile(
                  icon: Icons.image,
                  text: "Gallery",
                  onTap: selectGalleryImage,
                ),
                const SizedBox(
                  width: 20,
                ),
                OptionsForProfile(
                  icon: CupertinoIcons.camera_fill,
                  text: "Camera",
                  onTap: selectCameraImage,
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: _themeColors.cameraIconColor(context),
      behavior: SnackBarBehavior.fixed,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class OptionsForProfile extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  OptionsForProfile({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
  });
  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _themeColors.blueColor, width: 2),
            ),
            child: Icon(
              icon,
              size: 28,
              color: _themeColors.blueColor,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: _themeColors.textColor(context),
          ),
        ),
      ],
    );
  }
}
