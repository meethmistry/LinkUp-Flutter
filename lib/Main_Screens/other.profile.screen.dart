import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final Map<String, String> user;

  const OtherUserProfileScreen({super.key, required this.user});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  final ThemeColors _themeColors = ThemeColors();
  bool _notification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(widget.user['imageUrl']!),
          ),
          const SizedBox(height: 20),
          Text(
            widget.user['name']!,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _themeColors.textColor(context),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.user['email']!,
            style: TextStyle(
              fontSize: 16,
              color: _themeColors.textColor(context),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.user['isStatus'] == "true" ? "Online" : "Offline",
            style: TextStyle(
              fontSize: 14,
              color:
                  widget.user['isStatus'] == "true" ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.call, "Call"),
              _buildActionButton(Icons.videocam, "Video Call"),
              _buildActionButton(Icons.share, "Share"),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: _themeColors.iconColor(context), height: 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    color: _themeColors.textColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: _notification,
                  onChanged: (bool value) {
                    setState(() {
                      _notification = value;
                    });
                  },
                  activeColor:
                      _themeColors.blueColor, // Customize active switch color
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: _themeColors.blueColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon),
            color: Colors.white,
            onPressed: () {
              // Add your onPressed functionality here
            },
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _themeColors.textColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
