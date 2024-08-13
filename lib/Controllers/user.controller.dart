import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
}
