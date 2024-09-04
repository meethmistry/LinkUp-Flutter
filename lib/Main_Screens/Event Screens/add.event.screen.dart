import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:linkup/Authentications/Buied_User_Profile/profile.image.widget.dart';
import 'package:linkup/Controllers/event.controller.dart';
import 'package:linkup/Controllers/user.controller.dart';
import 'package:linkup/Models/user.model.dart';
import 'package:linkup/Theme/app.theme.dart';
import 'package:linkup/Theme/loading.indicator.dart';
import 'package:linkup/Utilities/Dialog_Box/custom.dialogbox.dart';
import 'package:linkup/Utilities/Snack_Bar/custom.snackbar.dart';
import 'package:linkup/Utilities/Snack_Bar/gallery.or.camera.snackbar.dart';
import 'package:linkup/Widgets/Form_Controllers/date.picker.dart';
import 'package:linkup/Widgets/Form_Controllers/textfiled.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({super.key});

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final EventController _eventController = EventController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final UserFirebaseController _userFirebaseController =
      UserFirebaseController();
  List<UserFirebase> users = [];

  Map<String, bool> selectedUsers = {}; // Track selected users

  void getUsers() async {
    try {
      List<UserFirebase> fetchedUsers =
          await _userFirebaseController.getChatUsersForEvent();
      setState(() {
        users = fetchedUsers;
        // Initialize selected users map
        for (var user in users) {
          selectedUsers[user.id!] = false;
        }
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();

    _startDateController.text = DateFormat('dd/MM/yyyy')
        .format(DateTime.now()); // Default to current date
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  final ThemeColors _themeColors = ThemeColors();

  // code for image

  Uint8List? _image;
  final ProfileImageWithButton _profileImageWithButton = ProfileImageWithButton(
    onButtonPressed: () {},
  );

  Future<void> selectGalleryImage() async {
    Uint8List im = await _profileImageWithButton.pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Future<void> selectCameraImage() async {
    Uint8List im = await _profileImageWithButton.pickImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  _removeImage() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    void showDialog(BuildContext context) {
      CustomDialogBox(
        message: "Do you want to remove profile image?",
        buttonOne: "No",
        buttonActionOne: () {
          Navigator.of(context).pop();
        },
        buttonTwo: "Remove",
        buttonActionTwo: () {
          setState(() {
            _image = null;
          });
          Navigator.of(context).pop();
        },
      ).show(context);
    }

    showDialog(context);
  }

  _takeImage() {
    GalleryOrCamera()
        .show(context, selectGalleryImage, selectCameraImage, _removeImage);
  }

  //////////////////////////
// Function to fetch all values from the form and create an event
  void _createEvent() async {
    if (_formKey.currentState!.validate()) {
      LoadingIndicator.show();
      // Fetch form data
      String eventName = _nameController.text.trim();
      String startDate = _startDateController.text.trim();
      String endDate = _endDateController.text.trim();

      // Get selected members' IDs
      List<String> members = selectedUsers.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      // Get current user ID as admin ID
      String adminId = FirebaseAuth.instance.currentUser!.uid;

      await _eventController
          .createEvent(
        eventName: eventName,
        startDate: startDate,
        endDate: endDate,
        adminId: adminId,
        members: members,
        eventImage: _image,
      )
          .whenComplete(() {
        LoadingIndicator.dismiss();

        Navigator.pop(context);
      });
    } else {
      CustomSnackbar(
        text: 'Something want wrong',
        color: _themeColors.snackBarRed(context),
      ).show(context);
      LoadingIndicator.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Event",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileImageWithButton(
                    image: _image,
                    onButtonPressed: _takeImage,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                labelText: 'Event Name',
                prefixIcon: Icons.event,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomDatePickerField(
                labelText: 'Event Start Date',
                prefixIcon: Icons.calendar_today,
                controller: _startDateController,
                onDateSelected: () =>
                    _selectDate(context, _startDateController),
              ),
              const SizedBox(height: 20),
              CustomDatePickerField(
                labelText: 'Event End Date',
                prefixIcon: Icons.calendar_today,
                controller: _endDateController,
                onDateSelected: () => _selectDate(context, _endDateController),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Text(
                      "Select Event Members",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: _themeColors.textColor(context),
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return CheckboxListTile(
                      value: selectedUsers[user.id] ?? false,
                      activeColor: _themeColors.blueColor,
                      checkColor: _themeColors.containerColor(context),
                      onChanged: (bool? value) {
                        setState(() {
                          selectedUsers[user.id!] = value ?? false;
                        });
                      },
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: user.profileImageUrl != null
                                ? NetworkImage(user.profileImageUrl!)
                                : null,
                            child: user.profileImageUrl == null
                                ? Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Text(user.userName ?? "Unknown"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: _createEvent,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery.sizeOf(context).width - 15,
          height: 55,
          decoration: BoxDecoration(
            color: _themeColors.blueColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "Create Event",
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                fontSize: 20),
          ),
        ),
      ),
    );
  }
}
