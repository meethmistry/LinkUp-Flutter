// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ChatFirebaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Method to insert a new chat record
  Future<void> createChat(String otherUserId) async {
    try {
      final chatId = Uuid().v4();
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DateTime now = DateTime.now();

      await _firestore.collection("chats").doc(chatId).set({
        'id': chatId,
        'userIds': <String>[userId, otherUserId],
        'lastMessage': "NULL",
        'seen': false,
        'createdAt': now.toIso8601String(),
        'lastUpdatedAt':
            now.toIso8601String(), // Include lastUpdatedAt during creation
      });
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

  // Method to update the last message of a chat
  Future<void> updateChatLastMessage(String lastMessage, String chatId) async {
    try {
      DateTime now = DateTime.now();

      await _firestore.collection("chats").doc(chatId).update({
        'lastMessage': lastMessage,
        'lastUpdatedAt': now
            .toIso8601String(), 
      });
    } catch (e) {
      print('Error updating chat last message: $e');
    }
  }

  // Method to get a single chat ID where both current user and other user are present
  Future<String?> getChatIdForCurrentUser(String otherUserId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final chatSnapshot = await _firestore
          .collection('chats')
          .where('userIds', arrayContains: currentUserId)
          .get();

      // Find the first chat document where the 'userId' list also contains the otherUserId
      final chatDoc = chatSnapshot.docs.firstWhere(
        (doc) {
          final userIds = List<String>.from(doc.data()['userIds'] ?? []);
          return userIds.contains(otherUserId);
        },
      );

      // Return the chat ID or null if no document is found
      return chatDoc != null
          ? (chatDoc.data() as Map<String, dynamic>)['id'] as String?
          : null;
    } catch (e) {
      print('Error getting chat ID: $e');
      return null;
    }
  }

  // check condition that chat already created or not
  Future<bool> shouldCreateNewChat(String otherUserId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Query the chats collection to find a document that contains both user IDs
      final querySnapshot = await _firestore
          .collection("chats")
          .where('userIds', arrayContains: currentUserId)
          .get();

      for (var doc in querySnapshot.docs) {
        List<String> userIds = List<String>.from(doc['userIds']);
        if (userIds.contains(otherUserId)) {
          // If both userId and otherUserId are found, return false (chat exists)
          return false;
        }
      }
      // If no document is found, return true (chat does not exist)
      return true;
    } catch (e) {
      print('Error checking chat existence: $e');
      return false;
    }
  }
}
