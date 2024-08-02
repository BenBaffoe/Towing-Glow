import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/models/historyinfo.dart';

class EditProfile extends StatefulWidget {
  final String userId;

  const EditProfile(
      {super.key, required this.userId, Historyinfo? userHistory});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();

  final avatarRef = FirebaseStorage.instance.ref();
  final ImagePicker _imagePicker = ImagePicker();
  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("userInfo");

  Uint8List? _image;
  String? profilePhoto;

  @override
  void initState() {
    super.initState();
    getProfilePhoto();
  }

  Future<void> getProfilePhoto() async {
    try {
      profilePhoto =
          await avatarRef.child('profile/avatar.png').getDownloadURL();
      setState(() {});
    } catch (e) {
      print('Error fetching profile photo: $e');
    }
  }

  Future<void> updateProfilePhoto(File profileImage) async {
    try {
      final ref = avatarRef.child('profile/avatar.png');
      await ref.putFile(profileImage);
      profilePhoto = await ref.getDownloadURL();
      setState(() {});
      Fluttertoast.showToast(msg: "Profile photo updated");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating profile photo: $e");
    }
  }

  Future<void> getProfile() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {
      final File profileImage = File(file.path);
      await updateProfilePhoto(profileImage);
    }
  }

  Future<void> showUserDialogAlert({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required String initialValue,
    required String fieldName,
  }) {
    controller.text = initialValue;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update $title"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: controller,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  userRef.child(widget.userId).update({
                    fieldName: controller.text.trim(),
                  }).then((value) {
                    controller.clear();
                    Fluttertoast.showToast(msg: "Updated Successful");
                    Navigator.pop(context);
                  }).catchError((error) {
                    Fluttertoast.showToast(msg: "Update failed: $error");
                  });
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 35,
          ),
        ),
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: userRef.child(widget.userId).onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('No data available'));
          }

          final userData =
              Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          final userName = userData['name'] ?? '';
          final userEmail = userData['email'] ?? '';
          final userPhone = userData['phone'] ?? '';

          return Column(
            children: [
              Stack(
                children: [
                  profilePhoto != null
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(profilePhoto!),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 65,
                            backgroundImage: NetworkImage(
                              "https://w7.pngwing.com/pngs/527/663/png-transparent-logo-person-user-person-icon-rectangle-photography-computer-wallpaper-thumbnail.png",
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 4,
                    right: 24,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.black,
                        height: 50,
                        width: 50,
                        child: IconButton(
                          onPressed: getProfile,
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 35,
                            color: Color.fromARGB(255, 90, 228, 168),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showUserDialogAlert(
                          context: context,
                          title: "Name",
                          controller: nameTextEditingController,
                          initialValue: userName,
                          fieldName: "name",
                        );
                      },
                      icon: const Icon(Icons.edit),
                    )
                  ],
                ),
              ),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showUserDialogAlert(
                          context: context,
                          title: "Email",
                          controller: emailTextEditingController,
                          initialValue: userEmail,
                          fieldName: "email",
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      " 0$userPhone ",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showUserDialogAlert(
                          context: context,
                          title: "Phone",
                          controller: phoneTextEditingController,
                          initialValue: userPhone,
                          fieldName: "phone",
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final XFile? file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    return null;
  }
}
