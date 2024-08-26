class ChatFirebase {
  String? id;
  List<String>? userId;
  String? lastMessage;  // Field for the last message ID in the chat
  bool? seen;           // Field for whether the last message has been seen
  DateTime? createdAt;
  DateTime? lastUpdatedAt;  // New field for the last updated timestamp

  ChatFirebase({
    this.id,
    this.userId,
    this.lastMessage,  // Initialize the new field
    this.seen,         // Initialize the new field
    this.createdAt,
    this.lastUpdatedAt,  // Initialize the lastUpdatedAt field
  });

  factory ChatFirebase.fromJson(Map<String, dynamic> json) => ChatFirebase(
        id: json['id'],
        userId: (json['userIds'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        lastMessage: json['lastMessage'],  // Assign the lastMessageId from JSON
        seen: json['seen'],                // Assign the seen from JSON
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        lastUpdatedAt: json['lastUpdatedAt'] != null  // Parse lastUpdatedAt from JSON
            ? DateTime.parse(json['lastUpdatedAt'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userIds': userId,
        'lastMessage': lastMessage,  // Include lastMessageId in the JSON output
        'seen': seen,                // Include seen in the JSON output
        'createdAt': createdAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),  // Include lastUpdatedAt in the JSON output
      };
}
