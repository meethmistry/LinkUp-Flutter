import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup/Models/event.model.dart';
import 'package:uuid/uuid.dart';

class EventController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

// Method to create a new event record
  Future<void> createEvent({
    required String eventName,
    required String startDate,
    required String endDate,
    required String adminId,
    required List<String> members,
    Uint8List? eventImage, // Optional parameter for event image
  }) async {
    try {
      final eventId = Uuid().v4(); // Generate a unique ID for the event
      DateTime now = DateTime.now(); // Get the current time

      // Prepare the event data to be saved in Firestore
      Map<String, dynamic> eventData = {
        'id': eventId,
        'eventName': eventName,
        'startDate': startDate,
        'endDate': endDate,
        'adminId': adminId,
        'members': members,
        'isEnd': false,
        'createdAt': now.toIso8601String(),
        'lastUpdatedAt': now.toIso8601String(),
      };

      // If an event image is provided, upload it to Firebase Storage and add the URL to event data
      if (eventImage != null) {
        String? imageUrl = await uploadEventImageToStorage(eventImage, eventId);
        if (imageUrl != null) {
          eventData['eventImageUrl'] = imageUrl;
        }
      }

      // Save the event data to Firestore
      await _fireStore.collection("events").doc(eventId).set(eventData);
      print('Event created successfully!');
    } catch (e) {
      print('Error creating event: $e');
    }
  }

  // Pick Event Image
  Future<Uint8List?> pickEventImage(ImageSource source) async {
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
      return null;
    }
  }

// Upload Event Image to Storage
  Future<String?> uploadEventImageToStorage(
      Uint8List? image, String eventId) async {
    if (image == null) {
      return null;
    }
    try {
      Reference ref =
          _firebaseStorage.ref().child('EventImages').child(eventId);
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

// Method to fetch events where adminId == currentUserId or members contains currentUserId
  Future<List<Event>> fetchEvents() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DateTime now = DateTime.now(); // Current date

      // Fetch events where adminId == currentUserId
      QuerySnapshot adminEventsSnapshot = await _fireStore
          .collection('events')
          .where('adminId', isEqualTo: currentUserId)
          .get();

      // Fetch events where members contains currentUserId
      QuerySnapshot memberEventsSnapshot = await _fireStore
          .collection('events')
          .where('members', arrayContains: currentUserId)
          .get();

      // Combine the events
      List<Event> events = [];

      // Process events where adminId == currentUserId
      for (var doc in adminEventsSnapshot.docs) {
        Event event = Event.fromMap(doc.data() as Map<String, dynamic>);

        // Check if the event's endDate is in the past
        if (event.endDate != null && event.endDate!.isBefore(now)) {
          // Update isEnd to true if the event has ended
          await updateEventIsEnd(event.id);
        } else {
          // Add event to the list if it hasn't ended
          events.add(event);
        }
      }

      // Process events where members contains currentUserId
      for (var doc in memberEventsSnapshot.docs) {
        Event event = Event.fromMap(doc.data() as Map<String, dynamic>);

        // Check if the event's endDate is in the past
        if (event.endDate != null && event.endDate!.isBefore(now)) {
          // Update isEnd to true if the event has ended
          await updateEventIsEnd(event.id);
        } else {
          // Add event to the list if it hasn't ended and is unique
          if (!events.any((e) => e.id == event.id)) {
            events.add(event);
          }
        }
      }

      return events;
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

// Method to update the isEnd field to true for a specific event
  Future<void> updateEventIsEnd(String eventId) async {
    try {
      // Reference to the event document in Firestore
      DocumentReference eventRef = _fireStore.collection("events").doc(eventId);

      // Update the isEnd field to true
      await eventRef.update({
        'isEnd': true,
        'lastUpdatedAt':
            DateTime.now().toIso8601String(), // Update the lastUpdatedAt field
      });

      print('Event isEnd updated to true successfully!');
    } catch (e) {
      print('Error updating isEnd: $e');
    }
  }
}
