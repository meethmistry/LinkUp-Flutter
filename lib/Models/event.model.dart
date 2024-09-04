import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String eventName;
  String adminId;
  List<String> members;
  String? eventProfileImage;
  DateTime? startDate;
  DateTime? endDate;
  DateTime createdAt;
  DateTime lastUpdatedAt;
  bool isEnd; // Make this non-nullable and default to false

  Event({
    required this.id,
    required this.eventName,
    required this.adminId,
    required this.members,
    this.eventProfileImage,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.isEnd = false, // Default to false if not provided
  });

  // Factory constructor for creating an Event instance from a map (e.g., JSON)
  factory Event.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) {
        return date.toDate(); // Handle Firestore Timestamps
      } else if (date is String) {
        try {
          return DateTime.parse(date); // ISO 8601 format
        } catch (_) {
          final split = date.split('/');
          if (split.length == 3) {
            final day = int.parse(split[0]);
            final month = int.parse(split[1]);
            final year = int.parse(split[2]);
            return DateTime(year, month, day);
          }
          return DateTime.now(); // Fallback
        }
      }
      return DateTime.now(); // Fallback
    }

    return Event(
      id: map['id'] ?? '',
      eventName: map['eventName'] ?? '',
      adminId: map['adminId'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      eventProfileImage: map['eventImageUrl'],
      startDate: parseDate(map['startDate']),
      endDate: parseDate(map['endDate']),
      createdAt: parseDate(map['createdAt']),
      lastUpdatedAt: parseDate(map['lastUpdatedAt']),
      isEnd: map['isEnd'] ?? false, // Default to false if null
    );
  }

  // Method to convert an Event instance to a map (e.g., JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventName': eventName,
      'adminId': adminId,
      'members': members,
      'eventImageUrl': eventProfileImage,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
      'isEnd': isEnd, // Include the field in the map
    };
  }
}
