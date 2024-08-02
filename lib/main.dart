import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onroadvehiclebreakdowwn/Info/app_info.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/editprofile.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/localNotification.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/serviceproviderlocaton.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/splashscreen.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/userhome.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/userlogin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotifications.init();

  await Firebase.initializeApp();

  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyBt9LHHiLzPA-F1iUjaUlGWPEWpCe9mSq0",
  //         appId: "1:846686411265:android:ff18939adfc822b0aa7e00",
  //         messagingSenderId: "846686411265",
  //         projectId: "roadtoll-1"),
  //   );
  // }

  await Permission.locationWhenInUse.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light(
          useMaterial3: true,
        ),
        routes: {
          '/home': (context) => const Userhome(),
          // '/service-request': (context) => const Serviceproviderlocation(
          //       data: null,
          //       payload: null,
          //     ),
        },
        home: const UserLogin(),
      ),
    );
  }
}
