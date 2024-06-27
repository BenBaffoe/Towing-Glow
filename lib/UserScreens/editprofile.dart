import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/compute/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();

  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("userInfo");

  Future<void> showUserPhoneDialogAlert(BuildContext context, String name) {
    emailTextEditingController.text = name;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneTextEditingController,
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
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "phone": phoneTextEditingController.text.trim(),
                  }).then((value) {
                    phoneTextEditingController.clear();
                    Fluttertoast.showToast(msg: "Update Successful");
                  });
                  Navigator.pop(context);
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

  Future<void> showUserEmailDialogAlert(BuildContext context, String name) {
    emailTextEditingController.text = name;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailTextEditingController,
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
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "email": emailTextEditingController.text.trim(),
                  }).then((value) {
                    emailTextEditingController.clear();
                    Fluttertoast.showToast(msg: "Updated Successful");
                  });
                  Navigator.pop(context);
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

  Future<void> showUserNameDialogAlert(BuildContext context, String name) {
    nameTextEditingController.text = name;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameTextEditingController,
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
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": nameTextEditingController.text.trim(),
                  }).then((value) {
                    nameTextEditingController.clear();
                    Fluttertoast.showToast(msg: "Updated Successful");
                  });
                  Navigator.pop(context);
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

  Uint8List? _image;

  void _selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
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
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              _image != null
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: MemoryImage(_image!),
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
                      onPressed: _selectImage,
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
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 00, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${userModelCurrentInfo!.name!}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showUserNameDialogAlert(
                          context, userModelCurrentInfo!.name!);
                    },
                    icon: Icon(
                      Icons.edit,
                    ))
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${userModelCurrentInfo!.email!}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showUserEmailDialogAlert(
                        context, userModelCurrentInfo!.email!);
                  },
                  icon: Icon(
                    Icons.edit,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " 0${userModelCurrentInfo!.phone!}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showUserPhoneDialogAlert(
                        context, userModelCurrentInfo!.phone!);
                  },
                  icon: Icon(
                    Icons.edit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
  }
}
