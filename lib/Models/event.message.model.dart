import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore's Timestamp

class EventMessage {
  String? id; // Unique identifier for the message
  String? eventId; // ID of the event to which this message belongs
  String? content; // Content of the message
  String? fileName; // Name of the file, if applicable
  MessageTypeEvent? messageType; // Type of the message (e.g., text, image, etc.)
  String? senderId; // ID of the user who sent the message
  String? senderName; // Name of the user who sent the message
  DateTime? timestamp; // Timestamp of when the message was sent

  EventMessage({
    this.id,
    this.eventId,
    this.content,
    this.fileName,
    this.messageType,
    this.senderId,
    this.senderName,
    this.timestamp,
  });

  // Factory method to create an instance from JSON
  factory EventMessage.fromJson(Map<String, dynamic> json) {
    return EventMessage(
      id: json['id'],
      eventId: json['eventId'],
      content: json['content'],
      fileName: json['fileName'],
      messageType: json['messageType'] != null ? MessageTypeEvent.values[json['messageType']] : null,
      senderId: json['senderId'],
      senderName: json['senderName'],
      timestamp: json['timestamp'] != null 
          ? (json['timestamp'] is Timestamp 
             ? (json['timestamp'] as Timestamp).toDate() 
             : DateTime.parse(json['timestamp']))
          : null,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'content': content,
    'fileName': fileName,
    'messageType': messageType?.index, // Store the enum index as an integer
    'senderId': senderId,
    'senderName': senderName,
    'timestamp': timestamp?.toIso8601String(),
  };
}

enum MessageTypeEvent {
  text,
  image,
  video,
  audio,
  file,
  location,
}
