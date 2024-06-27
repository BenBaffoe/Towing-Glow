import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
      body: Stack(
        children: [
          _image != null
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    radius: 85,
                    backgroundImage: MemoryImage(_image!),
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 75,
                    backgroundImage: NetworkImage(
                      "https://w7.pngwing.com/pngs/527/663/png-transparent-logo-person-user-person-icon-rectangle-photography-computer-wallpaper-thumbnail.png",
                    ),
                  ),
                ),
          Positioned(
            bottom: 1,
            left: 136,
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
