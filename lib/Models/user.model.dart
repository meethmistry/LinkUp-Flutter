class UserFirebase {
  String? id;
  String? userName;
  String? email;
  String? number;
  String? about;
  List<String>? chats;
  bool? isOnline;
  DateTime? lastSeen;
  DateTime? createdAt;
  DateTime? lastUpdatedAt;
  String? profileImageUrl; // New field for profile image URL

  UserFirebase({
    this.id,
    this.userName,
    this.email,
    this.number,
    this.about,
    this.chats,
    this.isOnline,
    this.lastSeen,
    this.createdAt,
    this.lastUpdatedAt,
    this.profileImageUrl, // Initialize the new field
  });

  // Factory method to create an instance from JSON
  factory UserFirebase.fromJson(Map<String, dynamic> json) => UserFirebase(
        id: json['id'],
        userName: json['userName'],
        email: json['email'],
        number: json['number'],
        about: json['about'],
        chats:
            (json['chats'] as List<dynamic>?)?.map((e) => e as String).toList(),
        isOnline: json['isOnline'],
        lastSeen:
            json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        lastUpdatedAt: json['lastUpdatedAt'] != null
            ? DateTime.parse(json['lastUpdatedAt'])
            : null,
        profileImageUrl:
            json['profileImage'], // Parse the new field from JSON
      );

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'email': email,
        'number': number,
        'about': about,
        'chats': chats,
        'isOnline': isOnline,
        'lastSeen': lastSeen?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
        'profileImage':
            profileImageUrl, // Include the new field in the JSON output
      };
}


// show users with last message
class UserWithMessage {
  UserFirebase user;
  String lastMessage;

  UserWithMessage({
    required this.user,
    required this.lastMessage,
  });
}
