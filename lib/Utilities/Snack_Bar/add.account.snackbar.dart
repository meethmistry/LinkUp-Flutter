// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:linkup/Authentications/login.screen.dart';
import 'package:linkup/Theme/app.theme.dart';

class AddNewAccount {
  AddNewAccount();
  final ThemeColors _themeColors = ThemeColors();
  void show(BuildContext context) {
    Uint8List? image;
    final snackBar = SnackBar(
      margin: EdgeInsets.zero,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              image != null
                  ? CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: MemoryImage(image),
                    )
                  : const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"),
                    ),
              const SizedBox(
                width: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "John Deo",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _themeColors.textColor(context)),
                  ),
                  Text(
                    "johndeo123@gmail.com",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: _themeColors.textColor(context)),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const LoginScreen();
                },
              ));
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
}
