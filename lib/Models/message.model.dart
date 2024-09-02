class MessageFirebase {
  String? id;
  String? senderId; // ID of the user who sent the message
  String? receiverId; // ID of the user who receives the message
  String? chatId; // ID of the chat to which this message belongs
  MessageType? messageType; // Type of the message (e.g., text, image, etc.)
  String? content; // Content of the message
  DateTime? timestamp; // Timestamp of when the message was sent
  String? fileName; // Name of the file, if applicable

  MessageFirebase({
    this.id,
    this.senderId,
    this.receiverId,
    this.chatId,
    this.messageType,
    this.content,
    this.timestamp,
    this.fileName,
  }) {
    // If the message is a file type and fileName is not provided, set a default file name
    if ((messageType == MessageType.image ||
            messageType == MessageType.video ||
            messageType == MessageType.audio ||
            messageType == MessageType.file) &&
        (fileName == null || fileName!.isEmpty)) {
      final currentTime = DateTime.now().toIso8601String();
      String extension;

      switch (messageType) {
        case MessageType.image:
          extension = '.png'; // Default to .png for images
          break;
        case MessageType.video:
          extension = '.mp4'; // Default to .mp4 for videos
          break;
        case MessageType.audio:
          extension = '.mp3'; // Default to .mp3 for audio files
          break;
        case MessageType.file:
          extension = '.pdf'; // Default to .pdf for files; can be changed based on use case
          break;
        default:
          extension = '';
      }

      fileName = "$currentTime$extension";
    } else fileName ??= '';
  }

  // Factory method to create an instance from JSON
  factory MessageFirebase.fromJson(Map<String, dynamic> json) => MessageFirebase(
        id: json['id'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        chatId: json['chatId'],
        messageType: json['messageType'] != null ? MessageType.values[json['messageType']] : null,
        content: json['content'],
        timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
        fileName: json['fileName'] ?? '',
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
        'fileName': fileName,
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
