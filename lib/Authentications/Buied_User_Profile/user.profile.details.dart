// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/Authentications/Buied_User_Profile/profile.image.widget.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Main_Screens/main.screen.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Snack_Bar/custom.snackbar.dart';
import 'package:linkup/Utilities/Snack_Bar/gallery.or.camera.snackbar.dart';
import 'package:linkup/Widgets/Backgrounds/design.widgets.dart';
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';

class BuiledUserProfile extends StatefulWidget {
  final String? userId;
  const BuiledUserProfile({super.key, required this.userId});

  @override
  State<BuiledUserProfile> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<BuiledUserProfile> {
  @override
  void initState() {
    super.initState();
    if (widget.userId == null || widget.userId!.isEmpty) {
      Navigator.pop(context);
    }
  }

  final ThemeColors _themeColors = ThemeColors();
  final _formKey = GlobalKey<FormState>();
  final UserFirebaseController _userFirebaseController =
      UserFirebaseController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _abouteController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  Uint8List? _image;

  _saveDetails() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (_formKey.currentState!.validate()) {
      final name = _userNameController.text;
      final about = _abouteController.text;
      final number = _numberController.text;
      LoadingIndicator.show();

      final isTaken = await _userFirebaseController.isUserNameTaken(name);
      if (isTaken) {
        CustomSnackbar(
          text: 'Username already taken. Please choose another.',
          color: _themeColors.snackBarRed(context),
        ).show(context);
      } else {
        try {
          await _userFirebaseController.makeProfile(
              name, about, number, _image, widget.userId!);

          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MainScreen();
            },
          ));
        } catch (e) {
          CustomSnackbar(
            text: 'Something want wrong. Please! try again.',
            color: _themeColors.snackBarRed(context),
          ).show(context);
        } finally {
          LoadingIndicator.dismiss();
        }
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedCircle(
            top: -30,
            left: -150,
          ),
          PositionedCircle(
            top: 530,
            right: -150,
          ),
          Form(
              key: _formKey,
              child: CustomContainer(
                child: Column(
                  children: [
                    const HeaderText(text: "Make Your Profile"),
                    const SizedBox(
                      height: 15,
                    ),
                    ProfileImageWithButton(
                      image: _image,
                      onButtonPressed: _takeImage,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      controller: _userNameController,
                      labelText: "Username",
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.text,
                      pattern: r'^\w{3,}$',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      controller: _abouteController,
                      maxLines: 3,
                      labelText: "About",
                      prefixIcon: Icons.info,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      controller: _numberController,
                      labelText: "Number",
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.text,
                      pattern: r'^[789]\d{9}$',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      buttonText: "Save",
                      onClick: _saveDetails,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
