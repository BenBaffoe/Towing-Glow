// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:onroadvehiclebreakdowwn/Common/toast.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/userhome.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/userlogin.dart';
import 'package:onroadvehiclebreakdowwn/User_auth/firebase_auth_impementation.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  String? _validatePassword(String? value) {
    if (value != passwordController.text) {
      return " Passwords do not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 90, 228, 168),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 30,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 90, 228, 168),
        title: const Text(
          "Towing Glow",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 90, 228, 168)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Account",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 45),
                child: SizedBox(
                  height: 10,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 241, 235),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                )),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 50, 14, 0),
              child: Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[ a-z A-Z]+$').hasMatch(value)) {
                                return "Enter Name";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              floatingLabelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                          child: IntlPhoneField(
                            initialCountryCode: 'GH',
                            controller: phoneController,
                            decoration: const InputDecoration(
                              labelText: '  Phone',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              floatingLabelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0.0),
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              floatingLabelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                          child: TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                                      .hasMatch(value)) {
                                return "Password must contain numeric  or special characters";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              floatingLabelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0.0),
                          child: TextFormField(
                            controller: confirmPasswordController,
                            validator: _validatePassword,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                              floatingLabelStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // _signUp();
                              _submit();
                              // getData(nameController.text, emailController.text,
                              //     phoneController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 90, 228, 168),
                              fixedSize: const Size(30, 60),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              elevation: 2.0,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 5,
                                  )
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  )),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                              child: Center(
                                child: Text(
                                  "Already have an account?",
                                  style: TextStyle(shadows: [
                                    Shadow(
                                      color: Color.fromARGB(255, 53, 51, 51),
                                      blurRadius: 0.6,
                                      offset: Offset(0.2, 0.2),
                                    ),
                                  ], fontSize: 15),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const UserLogin()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Click here to sign in',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 90, 228, 168),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

//   void _signUp() async {
//

//     String email = emailController.text;
//     String password = passwordController.text;

//     if (formKey.currentState!.validate()) {
//       try {
//         User? user =
//             await _auth.createUserWithEmailAndPassword(email, password);
//         await Future.delayed(const Duration(seconds: 3));
//         if (user != null) {
//           showToast(message: "User is successfully created");
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const Userhome()),
//           );
//         } else {
//           showToast(message: "Some error occurred");
//         }
//
//   }
// }

  // void _submit() async {
  //
  //         Map userMap = {
  //
  //         };

  //         FirebaseFirestore userRef =
  //             FirebaseFirestore.instance.collection('userInfo').doc("userInfo").snapshots(),
  //         userRef.child(currentUser!.uid).set(userMap);
  //       }
  //       await Fluttertoast.showToast(msg: "User created");

  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (c) => const Userhome()));
  //     }).catchError((err) {
  //
  //     });
  //
  // }

  _submit() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (formKey.currentState!.validate()) {
        await firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((auth) async {
          currentUser = auth.user;

          if (currentUser != null) {
            Map userMap = {
              "id": currentUser!.uid,
              "name": nameController.text.trim(),
              "email": emailController.text.trim(),
              "phone": phoneController.text.trim(),
            };

            DatabaseReference userRef =
                FirebaseDatabase.instance.ref().child("userInfo");
            userRef.child(currentUser!.uid).set(userMap);
          }
          await Fluttertoast.showToast(msg: "User created");

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => const Userhome()));
        }).catchError((err) {
          Fluttertoast.showToast(msg: "Error: " + err.message);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Some inputs in the text field are not valid");
      }
    } catch (e) {
      showToast(message: "User already exists");
    }
    setState(() {
      isLoading = false;
    });
  }
}
