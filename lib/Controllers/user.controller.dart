import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/Models/chat.model.dart';
import 'package:linkup/Models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFirebaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Used of Signup Screen
  Future<String?> signUpUsers(String email, String password) async {
    String? firebaseUid;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        firebaseUid = cred.user!.uid;

        await _fireStore.collection("users").doc(firebaseUid).set({
          'id': firebaseUid,
          'userName': null,
          'email': email,
          'number': null,
          'about': null,
          'profileImage': null,
          'chats': <String>[],
          'isOnline': false,
          'lastSeen': null,
          'createdAt': DateTime.now().toIso8601String(),
          'lastUpdatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        firebaseUid = null;
      }
    } catch (e) {
      print(e.toString());
      firebaseUid = null;
    }
    return firebaseUid;
  }

  // Check if user name is exist or not
  Future<bool> isUserNameTaken(String userName) async {
    try {
      final userQuery = await _fireStore
          .collection('users')
          .where('userName', isEqualTo: userName)
          .get();
      return userQuery.docs.isNotEmpty;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }

  // Pick Profile image
  Future<Uint8List?> pickProfileImage(ImageSource source) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: source);
      if (file != null) {
        return await file.readAsBytes();
      } else {
        return null;
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  // upload to storage
  Future<String?> uploadProfileImageToStorage(Uint8List? image) async {
    if (image == null) {
      return null;
    }
    try {
      Reference ref = _firebaseStorage
          .ref()
          .child('UserProfileImage')
          .child(_auth.currentUser!.uid);
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // user profile update
  Future<String> makeProfile(String userName, String about, String number,
      Uint8List? _image, String userId) async {
    String res = "";
    try {
      if (userName.isNotEmpty && about.isNotEmpty && number.isNotEmpty) {
        String? storeImage = await uploadProfileImageToStorage(_image);
        await _fireStore.collection('users').doc(userId).update({
          'userName': userName,
          'number': number,
          'about': about,
          'profileImage': storeImage == null ? null : storeImage,
          'lastUpdatedAt': DateTime.now().toIso8601String(),
        });

        res = "suceess";
      } else {
        res = "All fields must be filled.";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // user profile update single values
  Future<String> updateProfile(
      String label, String value, String userId) async {
    String res = "";
    try {
      if (label.isNotEmpty && value.isNotEmpty) {
        await _fireStore.collection('users').doc(userId).update({
          label: value, // No need for quotes around label
          'lastUpdatedAt': DateTime.now().toIso8601String(),
        });
        res = "success"; // Corrected typo
      } else {
        res = "All fields must be filled.";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Login user
  Future<String> loginUsers(String email, String password) async {
    String res = "";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        // Fetch user details from Firestore
        DocumentSnapshot userDoc = await _fireStore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        // Save user details in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String>? accountsList = prefs.getStringList('accounts') ?? [];
        Map<String, String> userDetails = {
          'userName': userDoc['userName'],
          'email': email,
          'profileImage': userDoc['profileImage'] ?? '',
          'uid': userCredential.user!.uid,
          'password': password, // Save the password for switching accounts
        };

        // Remove existing entry if user is already logged in
        accountsList.removeWhere((account) {
          Map<String, String> existingDetails =
              Map<String, String>.from(jsonDecode(account));
          return existingDetails['uid'] == userCredential.user!.uid;
        });
        accountsList.add(jsonEncode(userDetails));
        await prefs.setStringList('accounts', accountsList);

        // Set the current account
        await prefs.setString('currentAccount', jsonEncode(userDetails));

        res = "Success";
      } else {
        res = "Fields must be filled.";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

// Logout user
  Future<void> logoutUser() async {
    try {
      // Sign out from Firebase Auth
      await _auth.signOut();

      // Remove current account from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentAccount = prefs.getString('currentAccount');
      if (currentAccount != null) {
        List<String>? accountsList = prefs.getStringList('accounts');
        accountsList?.remove(currentAccount);
        await prefs.setStringList('accounts', accountsList!);
      }
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  // fetch user detail by email
  Future<Map<String, dynamic>?> fetchUserDetailsByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        return {
          'userName': userData['userName'],
          'number': userData['number'],
          'about': userData['about'],
          'id': doc.id,
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  // fetch user detail by id
  Future<Map<String, dynamic>?> fetchUserDetailsById(String id) async {
    try {
      QuerySnapshot querySnapshot =
          await _fireStore.collection('users').where('id', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        return {
          'userName': userData['userName'],
          'number': userData['number'],
          'about': userData['about'],
          'email': userData['email'],
          'profileImage': userData['profileImage'],
          'id': doc.id,
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

// Method to search users by userName
  Future<List<UserFirebase>> searchUsers(String searchTerm) async {
    print(searchTerm);
    try {
      final usersSnapshot = await _fireStore
          .collection('users')
          .where('userName', isGreaterThanOrEqualTo: searchTerm)
          .where('userName', isLessThanOrEqualTo: searchTerm + '\uf8ff')
          .get();

      // Convert the results into a list of UserFirebase objects
      List<UserFirebase> users = usersSnapshot.docs
          .map((doc) =>
              UserFirebase.fromJson(doc.data() as Map<String, dynamic>))
          .where((user) => user.id != FirebaseAuth.instance.currentUser!.uid)
          .toList();

      // Debugging: Print each user profile image URL
      users.forEach((user) {
        print('User profile image URL: ${user.profileImageUrl}');
      });

      return users;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

//show users on chat list screen
  Future<List<UserWithMessage>> getChatUsers() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Retrieve the current user's chat IDs
      final currentUserSnapshot =
          await _fireStore.collection('users').doc(currentUserId).get();
      final currentUserChats =
          List<String>.from(currentUserSnapshot['chats'] ?? []);

      if (currentUserChats.isEmpty) {
        return [];
      }

      // Fetch users who have chat IDs that match the current user's chats
      final userSnapshot = await _fireStore
          .collection('users')
          .where('chats', arrayContainsAny: currentUserChats)
          .get();

      // Map the user documents to UserFirebase objects and exclude the current user
      final users = userSnapshot.docs
          .map((doc) =>
              UserFirebase.fromJson(doc.data() as Map<String, dynamic>))
          .where((user) => user.id != currentUserId)
          .toList();

      // Fetch chats related to current user's chats
      final chatSnapshots = await _fireStore
          .collection('chats')
          .where(FieldPath.documentId, whereIn: currentUserChats)
          .get();

      // Map chat documents to ChatFirebase objects
      final chats = chatSnapshots.docs
          .map((doc) =>
              ChatFirebase.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Create a list to hold users with their last message
      final usersWithMessages = <UserWithMessage>[];

      for (final user in users) {
        String lastMessage = "No message"; // Default message if none found
        if (user.chats != null) {
          for (final chatId in user.chats!) {
            final chat = chats.firstWhere((chat) => chat.id == chatId,
                orElse: () => ChatFirebase()); // Fallback if chat is not found

            if (chat.lastMessage != null) {
              lastMessage = chat.lastMessage!;
            }
          }
        }

        // Add the user with the last message to the list
        usersWithMessages.add(UserWithMessage(
          user: user,
          lastMessage: lastMessage,
        ));
      }

      // Sort users based on the order of chat IDs in currentUserChats
      usersWithMessages.sort((a, b) {
        final aIndex = a.user.chats != null
            ? currentUserChats.indexWhere((id) => a.user.chats!.contains(id))
            : -1;
        final bIndex = b.user.chats != null
            ? currentUserChats.indexWhere((id) => b.user.chats!.contains(id))
            : -1;

        return aIndex.compareTo(bIndex);
      });

      return usersWithMessages;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

//show users on chat list screen
  Future<List<UserFirebase>> getChatUsersForMultipalShere() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Retrieve the current user's chat IDs
      final currentUserSnapshot =
          await _fireStore.collection('users').doc(currentUserId).get();
      final currentUserChats =
          List<String>.from(currentUserSnapshot['chats'] ?? []);

      if (currentUserChats.isEmpty) {
        return [];
      }

      // Fetch users who have chat IDs that match the current user's chats
      final userSnapshot = await _fireStore
          .collection('users')
          .where('chats', arrayContainsAny: currentUserChats)
          .get();

      // Map the user documents to UserFirebase objects and exclude the current user
      final users = userSnapshot.docs
          .map((doc) =>
              UserFirebase.fromJson(doc.data() as Map<String, dynamic>))
          .where((user) => user.id != currentUserId)
          .toList();

      return users;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  Future<String> addChatId(String chatId, String otherUserId) async {
    String res = "";
    try {
      if (chatId.isNotEmpty) {
        // Get the current user's UID
        String currentUserId = FirebaseAuth.instance.currentUser!.uid;

        // Retrieve the current user's list of chat IDsR
        DocumentSnapshot userDoc =
            await _fireStore.collection('users').doc(currentUserId).get();
        List<dynamic>? currentChats = userDoc['chats'] ?? [];

        // If the chat ID exists, move it to the front, otherwise add it to the list
        if (currentChats!.contains(chatId)) {
          currentChats.remove(chatId);
        }
        currentChats.insert(0, chatId);

        // Update the Firestore document with the modified list
        await _fireStore.collection('users').doc(currentUserId).update({
          'chats': currentChats,
        });

        // Repeat the same process for the other user
        DocumentSnapshot otherUser =
            await _fireStore.collection('users').doc(otherUserId).get();
        List<dynamic>? otherUserChats = otherUser['chats'] ?? [];

        if (otherUserChats!.contains(chatId)) {
          otherUserChats.remove(chatId);
        }
        otherUserChats.insert(0, chatId);

        await _fireStore.collection('users').doc(otherUserId).update({
          'chats': otherUserChats,
        });

        res = "success";
      } else {
        res = "Chat ID is empty.";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
