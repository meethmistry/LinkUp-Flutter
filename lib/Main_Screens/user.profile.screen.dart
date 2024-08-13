import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/Authentications/Buied_User_Profile/profile.image.widget.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Snack_Bar/custom.snackbar.dart';
import 'package:linkup/Utilities/Snack_Bar/gallery.or.camera.snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final UserFirebaseController _userFirebaseController =
      UserFirebaseController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  late String name;
  late String about;
  late String number;

  Future<void> _fetchUserData() async {
    LoadingIndicator.show();
    try {
      final userData = await _userFirebaseController
          .fetchUserDetailsById(FirebaseAuth.instance.currentUser!.uid);
      String? userName = userData?['userName'];
      String? about = userData?['about'];
      String? number = userData?['number'];
      String image = userData?['profileImage'].toString() ?? '';
      Uint8List? imageBytes;
      if (image.isNotEmpty) {
        imageBytes = await _setImage(image);
      }
      setState(() {
        _userNameController.text = userName ?? '';
        _aboutController.text = about ?? '';
        _numberController.text = number ?? '';
        _image = imageBytes;
        name = userName ?? '';
        about = about ?? '';
        number = number ?? '';
      });
    } catch (e) {
      print(e.toString());
    } finally {
      LoadingIndicator.dismiss();
    }
  }

  Future<Uint8List?> _setImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }

  bool isEdit = false;
  late TextEditingController controller;
  late String lable;
  late IconData icon;
  late String value;

  Positioned _onEdit(TextEditingController controller, String label,
      String value, IconData icon) {
    controller.text = value;

    void onSave() async {
      bool valid = true;
      String fieldLabel;

      if (label == "Username") {
        fieldLabel = 'userName';
        if (controller.text.isEmpty) {
          valid = false;
          CustomSnackbar(
            text: 'Username cannot be empty.',
            color: _themeColors.snackBarRed(context),
          ).show(context);
        } else if (await _userFirebaseController
            .isUserNameTaken(controller.text)) {
          valid = false;
          CustomSnackbar(
            text: 'Username is already taken.',
            color: _themeColors.snackBarRed(context),
          ).show(context);
        }
      } else if (label == "About") {
        fieldLabel = 'about';
        if (controller.text.isEmpty) {
          valid = false;
          CustomSnackbar(
            text: 'About cannot be empty.',
            color: _themeColors.snackBarRed(context),
          ).show(context);
        }
      } else {
        fieldLabel = 'number';
        final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
        if (controller.text.isEmpty) {
          valid = false;
          CustomSnackbar(
            text: 'Number cannot be empty.',
            color: _themeColors.snackBarRed(context),
          ).show(context);
        } else if (!phoneRegex.hasMatch(controller.text)) {
          valid = false;
          CustomSnackbar(
            text: 'Please enter a valid Indian phone number.',
            color: _themeColors.snackBarRed(context),
          ).show(context);
        }
      }

      if (valid) {
        String result = await _userFirebaseController.updateProfile(
          fieldLabel,
          controller.text,
          FirebaseAuth.instance.currentUser!.uid,
        );

        if (result == "success") {
          setState(() {
            _fetchUserData();
            isEdit = false;
          });

          // Update ueser name in local storage
          if (lable == "Username") {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            // Update current account
            String? currentAccountJson = prefs.getString('currentAccount');
            if (currentAccountJson != null) {
              Map<String, dynamic> currentAccount =
                  jsonDecode(currentAccountJson);
              currentAccount['userName'] = _userNameController.text;
              await prefs.setString(
                  'currentAccount', jsonEncode(currentAccount));
              print(currentAccount);
            }

            // Update accounts list
            List<String>? accountsList = prefs.getStringList('accounts');
            if (accountsList != null) {
              for (int i = 0; i < accountsList.length; i++) {
                Map<String, dynamic> account = jsonDecode(accountsList[i]);
                if (account['uid'] == FirebaseAuth.instance.currentUser!.uid) {
                  account['userName'] = _userNameController.text;
                  accountsList[i] = jsonEncode(account);
                  print(accountsList[i]);
                  break;
                }
              }
              await prefs.setStringList('accounts', accountsList);
            }
          }
        } else {
          CustomSnackbar(
            text: 'Something went wrong. Please try again.',
            color: _themeColors.snackBarRed(context),
          ).show(context);
        }
      }
    }

    return Positioned(
      bottom: 30,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: _themeColors.containerColor(context),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller,
              autofocus: true,
              maxLines: label == "About" ? 3 : 1,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(
                  icon,
                  color: _themeColors.blueColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.save,
                    color: _themeColors.blueColor,
                  ),
                  onPressed: onSave, // Call the onSave function here
                ),
                floatingLabelStyle: TextStyle(color: _themeColors.blueColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _themeColors.blueColor),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _themeColors.blueColor),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEdit = false;
                      controller.text = value;
                    });
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: _themeColors.blueColor),
                  ),
                ),
                TextButton(
                  onPressed: onSave, // Call the onSave function here as well
                  child: Text(
                    "Save",
                    style: TextStyle(color: _themeColors.blueColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
        actions: [ChangeTheme()],
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
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
                  UserProfileField(
                    controller: _userNameController,
                    labelText: "Username",
                    icon: Icons.person,
                    onEdit: () {
                      setState(() {
                        isEdit = true;
                        controller = _userNameController;
                        lable = 'Username';
                        value = _userNameController.text;
                        icon = Icons.person;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  UserProfileField(
                    controller: _aboutController,
                    labelText: "About",
                    icon: Icons.info,
                    isReadOnly: !isEdit,
                    onEdit: () {
                      setState(() {
                        isEdit = true;
                        controller = _aboutController;
                        lable = 'About';
                        value = _aboutController.text;
                        icon = Icons.info;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  UserProfileField(
                      controller: _numberController,
                      labelText: "Number",
                      icon: Icons.phone,
                      onEdit: () {
                        setState(() {
                          isEdit = true;
                          controller = _numberController;
                          lable = 'Number';
                          value = _numberController.text;
                          icon = Icons.phone;
                        });
                      }),
                ],
              ),
            ),
            if (isEdit) _onEdit(controller, lable, value, icon),
          ],
        ),
      ),
    );
  }
}
