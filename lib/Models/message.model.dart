// class MessageFirebase {
//   String? id;
//   String? userId;
//   String? chatId;
//   MessageType? messageType;
//   String? content;
//   DateTime? timestamp;

//   MessageFirebase({
//     this.id,
//     this.userId,
//     this.chatId,
//     this.messageType,
//     this.content,
//     this.timestamp,
//   });

//   // Factory method to create an instance from JSON
//   factory MessageFirebase.fromJson(Map<String, dynamic> json) =>
//       MessageFirebase(
//         id: json['id'],
//         userId: json['userId'],
//         chatId: json['chatId'],
//         messageType: json['messageType'] != null
//             ? MessageType.values[json['messageType']]
//             : null,
//         content: json['content'],
//         timestamp: json['timestamp'] != null
//             ? DateTime.parse(json['timestamp'])
//             : null,
//       );

//   // Method to convert an instance to JSON
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'userId': userId,
//         'chatId': chatId,
//         'messageType': messageType?.index, // Store the enum index as an integer
//         'content': content,
//         'timestamp': timestamp?.toIso8601String(),
//       };
// }

// enum MessageType {
//   text,
//   image,
//   video,
//   audio,
//   file,
//   location,
// }

class MessageFirebase {
  String? id;
  String? senderId;      // ID of the user who sent the message
  String? receiverId;    // ID of the user who receives the message
  String? chatId;        // ID of the chat to which this message belongs
  MessageType? messageType; // Type of the message (e.g., text, image, etc.)
  String? content;       // Content of the message
  DateTime? timestamp;   // Timestamp of when the message was sent

  MessageFirebase({
    this.id,
    this.senderId,
    this.receiverId,
    this.chatId,
    this.messageType,
    this.content,
    this.timestamp,
  });

  // Factory method to create an instance from JSON
  factory MessageFirebase.fromJson(Map<String, dynamic> json) => MessageFirebase(
        id: json['id'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        chatId: json['chatId'],
        messageType: json['messageType'] != null
            ? MessageType.values[json['messageType']]
            : null,
        content: json['content'],
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : null,
      );

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'receiverId': receiverId,
        'chatId': chatId,
        'messageType': messageType?.index, // Store the enum index as an integer
        'content': content,
        'timestamp': timestamp?.toIso8601String(),
      };
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  location,
}
