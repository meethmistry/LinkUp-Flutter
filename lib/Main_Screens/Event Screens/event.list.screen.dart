import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {

  final List<Map<String, String>> events = [
    {
      'title': 'Event 1',
      'date': '2024-09-10',
      'description': 'Event 1 details...'
    },
    {
      'title': 'Event 2',
      'date': '2024-09-15',
      'description': 'Event 2 details...'
    },
    {
      'title': 'Event 3',
      'date': '2024-09-20',
      'description': 'Event 3 details...'
    },
  ];

  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Events",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: _themeColors.iconColor(context),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return InkWell(
                  onTap: () {

                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Text(
                        event['title']!.substring(0, 1),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      event['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${event['date']} - ${event['description']}",
                      maxLines: 1,
                      overflow: TextOverflow
                          .ellipsis, // This will hide remaining text
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
