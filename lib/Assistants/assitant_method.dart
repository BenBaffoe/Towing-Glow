import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/request_assistant.dart';
import 'package:onroadvehiclebreakdowwn/Info/app_info.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/models/directions.dart';
import 'package:onroadvehiclebreakdowwn/models/directions_details_info.dart';
import 'package:onroadvehiclebreakdowwn/models/user_modals.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("Service Providers")
        .child(currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeographicCoOrdinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googlesMapKey";

    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.recieveRequest(apiUrl);

    if (requestResponse != "Error Occurred No Response") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  static Future<DirectionsDetailsInfo?>
      obtainOriginToDestinationDirectionsDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionsDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$googlesMapKey";

    var responseDirectionsApi = await RequestAssistant.recieveRequest(
        urlOriginToDestinationDirectionsDetails);

    if (responseDirectionsApi == "Error Occurred") {
      return null;
    }

    DirectionsDetailsInfo directionsDetailsInfo = DirectionsDetailsInfo();
    directionsDetailsInfo.ePoints =
        responseDirectionsApi["routes"][0]["overview_polyline"]["points"];

    var convert = double.parse(responseDirectionsApi["routes"][0]["legs"][0]
            ["distance"]['text']
        .split(" ")[0]);

    convert = (convert / 3281);

    directionsDetailsInfo.distanceText = convert.toString();

    directionsDetailsInfo.distanceValue =
        responseDirectionsApi["routes"][0]["legs"][0]["distance"]["value"];

    directionsDetailsInfo.durationText =
        responseDirectionsApi["routes"][0]["legs"][0]["duration"]["text"];

    directionsDetailsInfo.durationValue =
        responseDirectionsApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionsDetailsInfo;
  }

  static void pauseLiveLocationUpdate() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);
  }
}
