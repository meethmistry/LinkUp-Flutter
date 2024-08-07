import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class SettingsDialogBox extends StatefulWidget {
  final List<Map<String, String>>? users;

  SettingsDialogBox({this.users});

  @override
  _SettingsDialogBoxState createState() => _SettingsDialogBoxState();

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }
}

class _SettingsDialogBoxState extends State<SettingsDialogBox> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, String>> _filteredUsers = [];
  final ThemeColors _themeColors = ThemeColors();

  @override
  void initState() {
    super.initState();
    _filteredUsers = widget.users ?? [];
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      _filteredUsers = widget.users
              ?.where((user) => user['name']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList() ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _themeColors.containerColor(context),
      actionsPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      content: Container(
        height: MediaQuery.sizeOf(context).height / 2,
        width: MediaQuery.sizeOf(context).width - 15,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              cursorColor: _themeColors.blueColor,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: _themeColors.blueColor),
                labelText: 'Search',
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _themeColors.blueColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _themeColors.blueColor),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['imageUrl']!),
                    ),
                    title: Text(user['name']!),
                    trailing: Checkbox(
                      value: false,
                      onChanged: (bool? value) {},
                      shape: const CircleBorder(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: _themeColors.blueColor),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Save',
            style: TextStyle(color: _themeColors.blueColor),
          ),
        ),
      ],
    );
  }
}
