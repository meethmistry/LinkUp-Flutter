import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/Theme/app.theme.dart';

class ProfileImageWithButton extends StatelessWidget {
  final Uint8List? image;
  final VoidCallback onButtonPressed;

 ProfileImageWithButton({
    super.key,
    this.image,
    required this.onButtonPressed,
  });

  final ThemeColors _themeColors = ThemeColors();

    // tack image from user
  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      print("no image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Colors.grey,
            backgroundImage: image != null
                ? MemoryImage(image!)
                : const NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s") as ImageProvider,
          ),
        ),
        Positioned(
          top: 90,
          left: 100,
          child: Container(
            alignment: Alignment.center,
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _themeColors.blueColor,
            ),
            child: IconButton(
              onPressed: onButtonPressed,
              icon: Icon(
                Icons.add_a_photo_outlined,
                size: 20,
                color: _themeColors.themeBasedIconColor(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}




