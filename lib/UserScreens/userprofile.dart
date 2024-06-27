// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'dart:typed_data';
// import 'package:image_picker/image_picker.dart';
// import 'package:onroadvehiclebreakdowwn/Common/toast.dart';
// import 'package:onroadvehiclebreakdowwn/UserScreens/userlogin.dart';
// import 'package:onroadvehiclebreakdowwn/global/global.dart';

// class UserProfile extends StatefulWidget {
//   const UserProfile({super.key});

//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   Uint8List? _image;

//   void _selectImage() async {
//     Uint8List img = await pickImage(ImageSource.gallery);
//     setState(() {
//       _image = img;
//     });
//   }

//   // final String userId = auth.currentUser!.uid;

//   /*final FirebaseAuth _auth = FirebaseAuth.instance;*/

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Profile",
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.w400, fontSize: 30),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 90, 228, 168),
//         leading: Builder(
//           builder: (context) => IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios_new,
//               color: Colors.white,
//               size: 35,
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           color: Color.fromARGB(255, 90, 228, 168),
//         ),
//         height: double.infinity,
//         width: double.infinity,
//         child: ListView(
//           children: [
//             Column(
//               children: [
//                 Stack(
//                   children: [
//                     _image != null
//                         ? Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: CircleAvatar(
//                               radius: 85,
//                               backgroundImage: MemoryImage(_image!),
//                             ),
//                           )
//                         : const Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: CircleAvatar(
//                               backgroundColor: Colors.black,
//                               radius: 75,
//                               backgroundImage: NetworkImage(
//                                 "https://w7.pngwing.com/pngs/527/663/png-transparent-logo-person-user-person-icon-rectangle-photography-computer-wallpaper-thumbnail.png",
//                               ),
//                             ),
//                           ),
//                     Positioned(
//                       bottom: 1,
//                       left: 136,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Container(
//                           color: Colors.black,
//                           height: 50,
//                           width: 50,
//                           child: IconButton(
//                             onPressed: _selectImage,
//                             icon: const Icon(
//                               Icons.camera_alt,
//                               size: 35,
//                               color: Color.fromARGB(255, 90, 228, 168),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('userInfo')
//                       .snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.hasError) {
//                       print('Error: ${snapshot.error}');
//                       return const Center(
//                         child: Text('Something went wrong'),
//                       );
//                     }

//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }

//                     QuerySnapshot querySnapshot = snapshot.data!;

//                     // Assuming you want to access the username of the first document
//                     DocumentSnapshot document = querySnapshot.docs.first;
//                     userName = document.get('Username');
//                     return Text(
//                       '$userName',
//                       style: const TextStyle(
//                           fontSize: 15, fontWeight: FontWeight.normal),
//                     );
//                   },
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                     ),
//                   ),
//                   width: 410,
//                   height: 600,
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(45, 34, 0, 26),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Container(
//                                 color: Colors.black,
//                                 height: 40,
//                                 width: 40,
//                                 child: IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(
//                                     Icons.edit,
//                                     size: 25,
//                                     color: Color.fromARGB(255, 90, 228, 168),
//                                     textDirection: TextDirection.ltr,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 elevation: 0,
//                                 backgroundColor: Colors.white,
//                                 shape: const RoundedRectangleBorder(
//                                     side: BorderSide(
//                                   style: BorderStyle.none,
//                                 )),
//                               ),
//                               child: const Text(
//                                 "Edit Profile",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.normal),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(45, 0, 0, 10),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Container(
//                                   color: Colors.black,
//                                   height: 40,
//                                   width: 40,
//                                   child: IconButton(
//                                     onPressed: () {},
//                                     icon: const Icon(
//                                       Icons.info_outline,
//                                       size: 25,
//                                       color: Color.fromARGB(255, 90, 228, 168),
//                                       textDirection: TextDirection.ltr,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                               child: ElevatedButton(
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                   elevation: 0,
//                                   backgroundColor: Colors.white,
//                                   shape: const RoundedRectangleBorder(
//                                       side: BorderSide(
//                                     style: BorderStyle.none,
//                                   )),
//                                 ),
//                                 child: const Text(
//                                   "User Info",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.normal),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(45, 26, 0, 20),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Container(
//                                   height: 40,
//                                   width: 40,
//                                   color: Colors.black,
//                                   child: IconButton(
//                                     onPressed: () {},
//                                     icon: const Icon(
//                                       Icons.history,
//                                       size: 25,
//                                       color: Color.fromARGB(255, 90, 228, 168),
//                                       textDirection: TextDirection.ltr,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
//                               child: ElevatedButton(
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                   elevation: 0,
//                                   backgroundColor: Colors.white,
//                                   shape: const RoundedRectangleBorder(
//                                       side: BorderSide(
//                                     style: BorderStyle.none,
//                                   )),
//                                 ),
//                                 child: const Text(
//                                   "Trip History",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.normal),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(45, 12, 0, 26),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Container(
//                                   color: Colors.black,
//                                   height: 40,
//                                   width: 40,
//                                   child: IconButton(
//                                     onPressed: () {
//                                       Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const UserLogin()));
//                                     },
//                                     icon: const Icon(
//                                       Icons.logout_outlined,
//                                       size: 25,
//                                       color: Color.fromARGB(255, 90, 228, 168),
//                                       textDirection: TextDirection.ltr,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 FirebaseAuth.instance.signOut();
//                                 showToast(message: "User Logged Out");
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const UserLogin(),
//                                   ),
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 elevation: 0,
//                                 shape: const RoundedRectangleBorder(
//                                   side: BorderSide(style: BorderStyle.none),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Log Out",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 20,
//                                     color: Colors.black),
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// pickImage(ImageSource source) async {
//   final ImagePicker imagePicker = ImagePicker();

//   XFile? file = await imagePicker.pickImage(source: source);

//   if (file != null) {
//     return await file.readAsBytes();
//   }
// }
