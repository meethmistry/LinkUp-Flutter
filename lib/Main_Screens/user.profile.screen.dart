import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/Authentications/Buied_User_Profile/profile.image.widget.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Snack_Bar/gallery.or.camera.snackbar.dart';
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final ThemeColors _themeColors = ThemeColors();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Uint8List? _image;
  final ProfileImageWithButton _profileImageWithButton = ProfileImageWithButton(
    onButtonPressed: () {},
  );

  Future<void> selectGalleryImage() async {
    Uint8List im = await _profileImageWithButton.pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Future<void> selectCameraImage() async {
    Uint8List im = await _profileImageWithButton.pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  _removeImage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    void showDialog(BuildContext context) {
      CustomDialogBox(
        message: "Do you want to remove profile image?",
        buttonOne: "No",
        buttonActionOne: () {
          Navigator.of(context).pop();
        },
        buttonTwo: "Remove",
        buttonActionTwo: () {
          setState(() {
            _image = null;
          });
          Navigator.of(context).pop();
        },
      ).show(context);
    }

    showDialog(context);
  }

  _takeImage() {
    GalleryOrCamera()
        .show(context, selectGalleryImage, selectCameraImage, _removeImage);
  }

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  @override
  void initState() {
    _userNameController.text = "John Deo";
    _aboutController.text = "I am on my way 🏃🏃🏃";
    _numberController.text = "5986457895";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: _themeColors.appBarForgroundColor(context),
        title: const Text(
          "Profile",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        actions: [
          ChangeTheme()
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileImageWithButton(
                    image: _image,
                    onButtonPressed: _takeImage,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              EditableTextFormField(
                labelText: 'Username',
                prefixIcon: Icons.person,
                controller: _userNameController,
                pattern:
                    r'^[a-zA-Z0-9._]{3,}$', // Minimum 3 characters, alphanumeric and underscore
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  final regex = RegExp(r'^[a-zA-Z0-9._]{3,}$');
                  if (!regex.hasMatch(value)) {
                    return 'Invalid username';
                  }
                  return null;
                },
              ),
              EditableTextFormField(
                labelText: 'About',
                prefixIcon: Icons.info,
                controller: _aboutController,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
              ),
              EditableTextFormField(
                labelText: 'Phone Number',
                prefixIcon: Icons.phone,
                controller: _numberController,
                keyboardType: TextInputType.phone,
                pattern: r'^[6-9]\d{9}$', // Indian phone number format
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  final regex = RegExp(r'^[6-9]\d{9}$');
                  if (!regex.hasMatch(value)) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
