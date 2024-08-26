import 'package:flutter/material.dart';
import 'package:linkup/Controllers/chat.controller.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Main_Screens/chat.screen.dart';
import 'package:linkup/Models/user.model.dart';
import 'package:linkup/Theme/app.theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ThemeColors _themeColors = ThemeColors();

  final TextEditingController _searchController = TextEditingController();
  List<UserFirebase> _searchResults = [];
  final UserFirebaseController _firebaseController = UserFirebaseController();
  final ChatFirebaseController _chatFirebaseController =
      ChatFirebaseController();
  // Function to perform the search
  void _searchUser() async {
    String searchTerm = _searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      List<UserFirebase> searchResults =
          await _firebaseController.searchUsers(searchTerm);
      setState(() {
        _searchResults = searchResults;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchUser);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchUser);
    _searchController.dispose();
    super.dispose();
  }

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
              controller: _searchController,
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
      body: _buildSearchResults(),
    );
  }

  // Widget to build the search results
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'No users found',
          style: TextStyle(color: _themeColors.textColor(context)),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          UserFirebase user = _searchResults[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: user.profileImageUrl != null
                    ? NetworkImage(user.profileImageUrl!)
                    : const NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"),
              ),
              title: Text(
                user.userName ?? '',
                style: TextStyle(
                    color: _themeColors.textColor(context), fontSize: 18),
              ),
              onTap: () async {
                bool shouldCreateChat =
                    await _chatFirebaseController.shouldCreateNewChat(user.id!);
                if (shouldCreateChat)
                  await _chatFirebaseController.createChat(user.id!);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return UserChatScreen(user: user);
                  },
                ));
              },
            ),
          );
        },
      );
    }
  }
}
