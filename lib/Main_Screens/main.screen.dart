import 'package:flutter/material.dart';
import 'package:linkup/Main_Screens/Event%20Screens/event.list.screen.dart';
import 'package:linkup/Main_Screens/chatlist.screen.dart';
import 'package:linkup/Main_Screens/user.profile.screen.dart';
import 'package:linkup/Theme/app.theme.dart';

class MainScreen extends StatefulWidget {
  @override
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens for navigation
  static const List<Widget> _screens = <Widget>[
    ChatListScreen(),
    EventListScreen(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _themeColors.blueColor,
        unselectedItemColor: _themeColors.iconColor(context),
        onTap: _onItemTapped,
      ),
    );
  }
}
