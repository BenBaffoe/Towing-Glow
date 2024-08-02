import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onroadvehiclebreakdowwn/models/directions_details_info.dart';
import 'package:onroadvehiclebreakdowwn/models/user_modals.dart';

UserModel? userModelCurrentInfo;

String driverCarDetails = "";

UserModel? globalUser;

String driverName = "";

String cloudMessagingServerToken = "";

List serviceProviderList = [];

double countRatings = 0.0;

StreamSubscription<Position>? streamSubscriptionPosition;

// String userDropOffAddress = "";

// final FirebaseAuth auth = FirebaseAuth.instance;

String titleStarsRating = "";

// String userName = "";

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;

LatLng? driverPosition;

const String StripePublicKey =
    "pk_test_51PhSpLDBSBsOjpSFMy74OjlDjudb4edRfLI6yJzgyEiop8usiydm4jyLHxfSSFX7sY5kNRJhPlvYXRKSRVMt7Wnh00YeF54Vhf";
const Stribesecretkey =
    "sk_test_51PhSpLDBSBsOjpSFIFryaaGX7XmwVBb9RTnL0PQlaHV7OhpjY2qqIvR6iHHifChnFOlneguM8LR05OICqwEfJcBi00jPEZKpcT";

// UserModel? u serModelCurrentInfo;

// Future<void> getData(String _nameController, String _emailController,
//     String _phoneController) async {
//   CollectionReference userInfo =
//       FirebaseFirestore.instance.collection('userInfo');

//   return userInfo
//       .add({
//         'Username': _nameController.toString(),
//         'Email': _emailController.toString(),
//         'Phone': _phoneController.toString(),
//       })
//       .then((value) => print('New user added'))
//       .catchError((error) => print('Failed to add user'));
// }

String paystackApi = "sk_test_be297806a4038777e387f3f3f02dc9dc0cc371ad";
String password = "pk_test_c4273ad5f236a8dc96ae447f3311d0b52ef4e259";
String googlesMapKey = "AIzaSyBqtAzED0r5rQvQjsncU10np2bIAUsg6ZY";
const CameraPosition googlePlexIntitialPosition = CameraPosition(
    bearing: 244.64,
    target: LatLng(6.6833, -1.6163),
    tilt: 59.440717697143555,
    zoom: 13.151926040649414);

DirectionsDetailsInfo? serviceDirectionDetailsInfo;
