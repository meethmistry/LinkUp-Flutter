import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Authentications/login.screen.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Main_Screens/user.profile.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/account.setting.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/call.history.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/chat.setting.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/notification.setting.screen.dart';
import 'package:linkup/Settings/Sub_Setting_Screens/privacy.setting.screen.dart';
import 'package:linkup/Settings/Widgets/main.settings.widget.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Snack_Bar/add.account.snackbar.dart';
import 'package:linkup/Utilities/Snack_Bar/custom.snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:linkup/splash.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainSettingScreen extends StatefulWidget {
  const MainSettingScreen({super.key});

  @override
  State<MainSettingScreen> createState() => _MainSettingScreenState();
}

class _MainSettingScreenState extends State<MainSettingScreen> {
  final ThemeColors _themeColors = ThemeColors();
  final UserFirebaseController _userFirebaseController =
      UserFirebaseController();
  Uint8List? _image;

  _navigation(Widget _page) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return _page;
      },
    ));
  }

  _logOut() async {
    LoadingIndicator.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _userFirebaseController.logoutUser().whenComplete(() async {
        // Fetch the next account to log in
        List<String>? updatedAccountsList = prefs.getStringList('accounts');
        if (updatedAccountsList != null && updatedAccountsList.isNotEmpty) {
          // Pick the first account from the list (or any other logic to choose an account)
          String nextAccount = updatedAccountsList.first;
          Map<String, dynamic> userDetails = jsonDecode(nextAccount);

          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userDetails['email']!,
            password: userDetails['password']!,
          );

          // Set the new current account
          await prefs.setString('currentAccount', nextAccount);

          // Navigate to SplashScreen to reload the app with the new account
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            ),
          );
        } else {
          // If no other accounts are available, navigate to login screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return SplashScreen();
          },
        ));
      });
    } catch (e) {
      CustomSnackbar(
        text: 'Something want wrong.',
        color: _themeColors.snackBarRed(context),
      ).show(context);
    }
    LoadingIndicator.dismiss();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  String userName = "";
  String email = "";

  Future<void> _fetchUserData() async {
    LoadingIndicator.show();
    try {
      final userData = await _userFirebaseController
          .fetchUserDetailsById(FirebaseAuth.instance.currentUser!.uid);
      userName = userData?['userName'] ?? "";
      email = userData?['email'] ?? "";
      String image = userData?['profileImage'].toString() ?? '';
      Uint8List? imageBytes;
      if (image.isNotEmpty) {
        imageBytes = await _setImage(image);
      }
      setState(() {
        _image = imageBytes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: _themeColors.appBarForgroundColor(context),
        title: const Text(
          "Settings",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
      body: Column(
        children: [
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const UserProfileScreen();
                },
              ));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"),
                        ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        email,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      AddNewAccount().show(context);
                    },
                    icon: Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: _themeColors.blueColor,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          const SizedBox(
            height: 20,
          ),
          CustomRowItem(
            leadingIcon: CupertinoIcons.profile_circled,
            isMain: true,
            text: "Account",
            onTap: () {
              _navigation(const AccountSettings());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.security,
            isMain: true,
            text: "Privacy",
            onTap: () {
              _navigation(const PrivacySetting());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.message_outlined,
            isMain: true,
            text: "Chats",
            onTap: () {
              _navigation(const ChatSettings());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.notifications,
            isMain: true,
            text: "Notifications",
            onTap: () {
              _navigation(NotificationSettings());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.history,
            isMain: true,
            text: "Call & Video Chat History",
            onTap: () {
              _navigation(CallOrVideoChatHistory());
            },
          ),
          CustomRowItem(
            leadingIcon: Icons.logout,
            isMain: true,
            text: "Logout",
            onTap: () {
              CustomDialogBox(
                  message: "Do you want to logout?",
                  buttonOne: "No",
                  buttonActionOne: () {
                    Navigator.of(context).pop();
                  },
                  buttonTwo: "Yes",
                  buttonActionTwo: () {
                    Navigator.of(context).pop();
                    _logOut();
                  }).show(context);
            },
          ),
        ],
      ),
    );
  }
}
