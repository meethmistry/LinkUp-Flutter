import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ThemeColors _themeColors = ThemeColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeColors.containerColor(context),
      appBar: AppBar(
        backgroundColor: _themeColors.containerColor(context),
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            alignment: Alignment.center,
            height: 45,
            decoration: BoxDecoration(
              color: _themeColors.searchFilledColor(context),
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextField(
              autofocus: true,
              cursorColor: _themeColors.blueColor,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: _themeColors.textColor(context),
                ),
                prefixIcon: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: _themeColors.textColor(context),
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
