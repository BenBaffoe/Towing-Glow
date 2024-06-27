import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/editprofile.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/userlogin.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

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

//  userName(){
//     if( userModelCurrentInfo = null && userModelCurrentInfo.name != null ){
//                 String userName = userModelCurrentInfo.name;        }
// }

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
              _image != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 2),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: MemoryImage(_image!),
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
              //     // Positioned(
              //     //   bottom: 1,
              //     //   left: 56,
              //     //   child: ClipRRect(
              //     //     borderRadius: BorderRadius.circular(20),
              //     //     child: Container(
              //     //       color: Colors.black,
              //     //       height: 50,
              //     //       width: 50,
              //     //       child: IconButton(
              //     //         onPressed: _selectImage,
              //     //         icon: const Icon(
              //     //           Icons.camera_alt,
              //     //           size: 25,
              //     //           color: Color.fromARGB(255, 90, 228, 168),
              //     //         ),
              //     //       ),
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
//               if (userModelCurrentInfo != null && userModelCurrentInfo.name != null) {
//   // Now it's safe to access userModelCurrentInfo.name
//   String userName = userModelCurrentInfo.name;
//   // ...
// } else {
//   // Handle the case where userModelCurrentInfo or name is null
//   // ...

//

// }
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 70, 20),
                child: Text(
                  userModelCurrentInfo!.name!,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              // // ),
              // // StreamBuilder<QuerySnapshot>(
              // //   stream: FirebaseFirestore.instance
              // //       .collection('userInfo')
              // //       .snapshots(),
              // //   builder: (BuildContext context,
              // //       AsyncSnapshot<QuerySnapshot> snapshot) {
              // //     if (snapshot.hasError) {
              // //       print('Error: ${snapshot.error}');
              // //       return const Center(
              // //         child: Text('Something went wrong'),
              // //       );
              // //     }

              // //     if (snapshot.connectionState == ConnectionState.waiting) {
              // //       return const Center(
              // //         child: CircularProgressIndicator(),
              // //       );
              // //     }

              // //     QuerySnapshot querySnapshot = snapshot.data!;

              // //     // Assuming you want to access the username of the first document
              // //     DocumentSnapshot document = querySnapshot.docs.first;
              // //     userName = document.get('Username');
              // //     return Text(
              // //       '$userName',
              // //       style: const TextStyle(
              // //           fontSize: 15, fontWeight: FontWeight.normal),
              // //     );
              // //   },
              // // ),
              // const SizedBox(
              //   height: 20,
              // ),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(5, 34, 0, 26),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(10),
                      //     child: Container(
                      //       color: Colors.black,
                      //       height: 40,
                      //       width: 40,
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: const Icon(
                      //           Icons.edit,
                      //           size: 25,
                      //           color: Color.fromARGB(255, 90, 228, 168),
                      //           textDirection: TextDirection.ltr,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(74, 20, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditProfile(),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.circular(10),
                        //     child: Container(
                        //       color: Colors.black,
                        //       height: 40,
                        //       width: 40,
                        //       child: IconButton(
                        //         onPressed: () {},
                        //         icon: const Icon(
                        //           Icons.info_outline,
                        //           size: 25,
                        //           color: Color.fromARGB(255, 90, 228, 168),
                        //           textDirection: TextDirection.ltr,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(74, 20, 0, 8),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "UserInfo",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            )),
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
                            onTap: () {},
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
                  SizedBox(
                    height: 260,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // FirebaseAuth.instance.signOut();
                            // // showToast(message: "User Logged Out");
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

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
  }
}
