import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/serviceproviderinfo.dart';
import 'package:onroadvehiclebreakdowwn/Common/toast.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/editprofile.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/history.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/payment_screen.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/paymentscreen.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/userlogin.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/models/historyinfo.dart';
import 'package:onroadvehiclebreakdowwn/models/retrievedata.dart';

class DrawerScreen extends StatefulWidget {
  ServiceProviderInfo? serviceProviderInfo;
  DrawerScreen({
    super.key,
    required this.serviceProviderInfo,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  Uint8List? _image;

  void _selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  String? profilePhoto;
  final avatarRef = FirebaseStorage.instance.ref();
  Future<void> getPhoto() async {
    profilePhoto = await avatarRef.child('profile/avatar.png').getDownloadURL();

    setState(() {});
  }

  Historyinfo? usersInfo;

  String userName = "";
  String userEmail = "";
  String userPhone = "";
  String userId = "";
  String service = "";
  String userLocation = "";

  void retrieveUserData() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("userInfo");

    // Get user data from Firebase
    userRef.child(firebaseAuth.currentUser!.uid).onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        userName = userData['name'] ?? '';
        userEmail = userData['email'] ?? '';
        userPhone = userData['phone'] ?? '';
        userId = userData['id'] ?? '';
        service = userData['service'] ?? '';
        userPhone = userData['phone'] ?? '';
        userLocation = userData['originAddress'] ?? '';

        setState(() {
          usersInfo = Historyinfo(
              userName: userName,
              userEmail: userEmail,
              userPhone: userPhone,
              service: service,
              id: userId,
              userLocation: userLocation);
        });
      }
      print(
          "Hoeoeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      print(usersInfo!.userEmail);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoto();
    retrieveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      // key:_scaffoldState,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 0, 20),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 6, 24, 0),
                child: Text(
                  "Profile",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
              profilePhoto != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 2),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(profilePhoto!),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 30, 10),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 65,
                        backgroundImage: NetworkImage(
                          "https://w7.pngwing.com/pngs/527/663/png-transparent-logo-person-user-person-icon-rectangle-photography-computer-wallpaper-thumbnail.png",
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 70, 20),
                child: usersInfo == null
                    ? Text("Loading....")
                    : Text(
                        usersInfo!.userName!,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(74, 20, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                      userHistory: usersInfo,
                                      userId: usersInfo!.id!,
                                    ),
                                  ));
                            },
                            child: const Text(
                              "Edit Profile",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          )),
                    ],
                  ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Padding(
                  //           padding: const EdgeInsets.fromLTRB(74, 20, 0, 8),
                  //           child: GestureDetector(
                  //             onTap: () {},
                  //             child: const Text(
                  //               "UserInfo",
                  //               style: TextStyle(
                  //                   fontSize: 18, color: Colors.black),
                  //             ),
                  //           )),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(44, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 4, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => History(
                                            userHistory: usersInfo,
                                          )));
                            },
                            child: const Text(
                              "History",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(44, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 4, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Payment_Screen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Paymnets",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 260,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _signOut();
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(60, 0, 0, 10),
                            child: Text(
                              "Log Out ",
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signOut() async {
    FirebaseAuth.instance.signOut();
    showToast(message: "User Logged Out");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const UserLogin()));
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
  }
}
