import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/assitant_method.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/signup.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/userhome.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/userlogin.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/pages/screen.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null
            ? AssistantMethods.readCurrentOnlineUserInfo()
            : null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => const Screen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const SignUp()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 4), () {
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => widget.child!),
    //       (route) => true);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("c"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Towing Glow",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
