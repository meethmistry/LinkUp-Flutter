import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkup/Authentications/login.screen.dart';
import 'package:linkup/splash.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linkup/Theme/app.theme.dart';

class AddNewAccount {
  AddNewAccount();
  final ThemeColors _themeColors = ThemeColors();

  void show(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? accountsList = prefs.getStringList('accounts');

    final snackBar = SnackBar(
      margin: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...accountsList?.map((account) {
                Map<String, String> userDetails =
                    Map<String, String>.from(jsonDecode(account));

                Widget avatar;

                // Check if the profileImage is Base64 or URL
                if (userDetails['profileImage'] != null &&
                    userDetails['profileImage']!.isNotEmpty) {
                  if (_isBase64(userDetails['profileImage']!)) {
                    // Handle Base64 image
                    Uint8List image =
                        base64Decode(userDetails['profileImage']!);
                    avatar = CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: MemoryImage(image),
                    );
                  } else {
                    // Handle URL image
                    avatar = CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          NetworkImage(userDetails['profileImage']!),
                    );
                  }
                } else {
                  // Fallback to default image
                  avatar = const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"),
                  );
                }

                return InkWell(
                  onTap: () async {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    prefs.setString('currentAccount', jsonEncode(userDetails));
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: userDetails['email']!,
                      password: userDetails['password']!,
                    );
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return SplashScreen();
                      },
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        avatar,
                        const SizedBox(
                          width: 25,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userDetails['userName'] ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: _themeColors.textColor(context)),
                            ),
                            Text(
                              userDetails['email'] ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: _themeColors.textColor(context)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList() ??
              [],
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return LoginScreen();
                },
              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 57,
                          width: 57,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Icon(
                            Icons.add,
                            color: _themeColors.iconColor(context),
                            size: 32,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Add Account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _themeColors.textColor(context)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _themeColors.containerColor(context),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Helper method to check if a string is Base64
  bool _isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }
}
