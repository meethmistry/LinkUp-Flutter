import 'package:flutter/material.dart';
import 'package:linkup/Controllers/event.controller.dart';
import 'package:linkup/Main_Screens/Event%20Screens/add.event.screen.dart';
import 'package:linkup/Main_Screens/Event%20Screens/event.chat.screen.dart';
import 'package:linkup/Models/event.model.dart';
import 'package:linkup/Theme/app.theme.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final ThemeColors _themeColors = ThemeColors();
  final EventController _eventController = EventController();
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  void getEvents() async {
    try {
      List<Event> fetchedEvents = await _eventController.fetchEvents();
      setState(() {
        events = fetchedEvents;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Events",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewEvent(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                  border: Border.all(color: _themeColors.blueColor, width: 1.5),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 22,
                    color: _themeColors.blueColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Add",
                    style: TextStyle(
                        color: _themeColors.blueColor,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: events.isEmpty
          ? Center(
              child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNewEvent(),
                  ),
                ).whenComplete(() {
                  getEvents();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 156, 173, 241),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Create Event",
                  style: TextStyle(
                      color: _themeColors.blueColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ))
          : Column(
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventChatScreen(event: event),
                            ),
                          ).whenComplete(() {
                            setState(() {
                              getEvents();
                            });
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: event.eventProfileImage != null
                                  ? NetworkImage(event.eventProfileImage!)
                                  : const NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFdoXe8AoCq0BUuu6LhgSGqwUdMUwdLdyPnQ&s"),
                            ),
                            title: Text(event.eventName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
