import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/Models/message.model.dart';
import 'package:uuid/uuid.dart';

class MessageFirebaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // Method to send a new message
  Future<void> sendMessage({
    required String chatId,
    required String receiverId, // Receiver ID as a parameter
    required MessageType messageType,
    required String content,
    String? fileName,
  }) async {
    try {
      final messageId = Uuid().v4();
      final senderId = FirebaseAuth
          .instance.currentUser!.uid; // Get the current user's ID as senderId

      final message = MessageFirebase(
        id: messageId,
        senderId: senderId,
        receiverId: receiverId, // Set receiverId
        chatId: chatId,
        messageType: messageType,
        content: content,
        fileName: fileName,
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection('messages')
          .doc(messageId)
          .set(message.toJson());
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Method to get all messages by chatId
  Future<List<MessageFirebase>> getMessagesByChatId(String chatId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('messages')
          .where('chatId', isEqualTo: chatId)
          .orderBy('timestamp', descending: true)
          .get();

      final messages = querySnapshot.docs.map((doc) {
        return MessageFirebase.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return messages;
    } catch (e) {
      print('Error retrieving messages: $e');
      return [];
    }
  }

  // shere images
  Future<Uint8List?> pickImageToShere(ImageSource source) async {
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

  Future<String?> uploadSheredImageToStorage(Uint8List? image) async {
    if (image == null) {
      return null;
    }
    try {
      Reference ref = _firebaseStorage
          .ref()
          .child('UserSharedImages')
          .child(_auth.currentUser!.uid)
          .child(Uuid().v4());
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // shere videos
  Future<XFile?> pickVideoToShare(ImageSource source) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickVideo(source: source);
      return file;
    } catch (e) {
      print('Error picking video: $e');
      return null;
    }
  }

  Future<String?> uploadSharedVideoToStorage(XFile? videoFile) async {
    if (videoFile == null) {
      return null;
    }
    try {
      Reference ref = _firebaseStorage
          .ref()
          .child('UserSharedVideos')
          .child(_auth.currentUser!.uid)
          .child(Uuid().v4());
      UploadTask uploadTask = ref.putFile(File(videoFile.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }

   // Method to pick documents
  Future<PlatformFile?> pickDocumentToShare() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // You can specify the type of file you want
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first; // Return the selected file
      }
    } catch (e) {
      print('Error picking document: $e');
    }
    return null;
  }

  Future<String?> uploadSharedDocumentToStorage(PlatformFile? documentFile) async {
    if (documentFile == null) {
      return null;
    }
    try {
      File file = File(documentFile.path!); // Ensure the path is not null
      Reference ref = _firebaseStorage
          .ref()
          .child('UserSharedDocuments')
          .child(_auth.currentUser!.uid)
          .child(Uuid().v4());
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading document: $e');
      return null;
    }
  }

}
