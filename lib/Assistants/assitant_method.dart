import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
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
import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class AssistantMethods {
  static void readCurrentOnlineUserInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("userInfo")
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
        "https:/maps.googleapis.com/maps/api/geocode/json?Latlng=${position.latitude},${position.longitude}&key=$googlesMapKey";

    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.recieveRequest(apiUrl);

    if (requestResponse != "Error Occured No Response") {
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
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude}, ${originPosition.longitude}&destination=${destinationPosition.latitude}, ${destinationPosition.longitude}&Key=$googlesMapKey";

    var responseDirectionsApi = await RequestAssistant.recieveRequest(
        urlOriginToDestinationDirectionsDetails);

    if (responseDirectionsApi == "Error Occured ") {
      return null;
    }

    DirectionsDetailsInfo directionsDetailsInfo = DirectionsDetailsInfo();
    directionsDetailsInfo.ePoints =
        responseDirectionsApi["routes"][0]["overview_polyline"]["points"];

    directionsDetailsInfo.distanceText =
        responseDirectionsApi["routes"][0]["legs"][0]["distance"]["text"];

    directionsDetailsInfo.distanceValue =
        responseDirectionsApi["routes"][0]["legs"][0]["distance"]["text"];

    directionsDetailsInfo.durationText =
        responseDirectionsApi["routes"][0]["legs"][0]["duration"]["text"];

    directionsDetailsInfo.durationValue =
        responseDirectionsApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionsDetailsInfo;
  }

  static Future<String> getAccessToken() async {
    //returns client id and secret
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "roadtoll-1",
      "private_key_id": "d1411d75e443431a625213f262f8e36f1e89f5d7",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDLVdNjVwCtAsPY\n08blvGW70J3FnGTJt5QBSy7NCYkAMOXXXyHj38IT/gZ2Z9nKLzOkQALONgAxqiXz\nHSPcnNwXTgEh3m7b9TpGvOco+LGnyTMKgGz1M4wPnhesSdTpKqUS4o89hwWwn+57\nGvZ+0oqmX/Z3Z32Ta3n0IFNeuVpDKBGjT/qfkCIzRu1p1cBjCvbUdZ3InZxMi5So\nSwaFAxC6hpLiKz+WHvfkS+jGHY6xkbvGbz5K9NvoLcynPaEvOMlsJ9G+exJkKvnd\n3HYD7d2itrUipUOdskvhXEcK3QXrRmRegP9rQjA+Q9wG4RQWClyw2ic7zf9TJ9mt\ntj1ePqRdAgMBAAECggEAHa/N1Bl2EiHENu+nK2WCiOr1Y04+ciuo9+NigDGzMeGc\nZ6xjsKG7noWeVe069pzw8jsc7b8j73GtvBKgvhXyFZOgRgdJXOMvJfgbMSKAyu7C\nJ/dbcRVHOVnV5PlGlOBSsjDSbvjmqMSWN0esKL9T2jn1LGEMtthLOYxP/8AaCzxs\niVfOXGbwCRDkk9XT5y4Q6bUTFMk34RhBkBKqFGAA50WMR5ocylP1FPNZLqVicl69\nA9CagHOaQPk7/dhQl8AcRKfyu+YcZXN/REEsAliEQaN0SdIskoaR9H9bU271iAy/\nPSWjchehGte2aWijYb5hyTAckhhkmaPTzlXT4SxWlQKBgQD4Eg5/yMnePBZ04hei\nkLz+ZVOaI/3bzRjws/bT3q/y2Cdk83ARYUDrz2+H6yQUQiXMjA2m9mpKVs51QlVj\nCteeLlg4oleMryn1MDWe9XUtL2mZABPuKk53t3o41Qe37KCvYzZgtLEvgWh0NRpr\ngUwbOw1o+HmFMKP/354oaVCbHwKBgQDR1bQbGGoFSaHQb7S0rKlGCdI8mV66hes7\n6d7dUXuLfedmlicpah3NV/o5b8Utx7CoVuc7fzi02eIO1SvrxVhZJCyGe9GJjbsI\n8qrtL9Rl3xGgctaC8TASZxS+M2rrS6rRfwt/iHTug4/TM5c1tkFuCVRDaq20OAhL\nJwKuXEvNAwKBgQC63Scs3LwreonT++ef3nVvEDa8mrYEV2edEYMxr8JMJMTwB2x4\nuxCjUPuLn/XqiLVecnVqOp5wZxlYPOKDG8y16+UqrCdU4zGw72LE3dMpeViLFwLs\nWdQH3B7mJpqM0mNsGkkA6bu6tDlRqBrBtoD01jPQybMIQE6ZVQIXINXGMwKBgQCN\nTC1arYb/BoUrGX2CyF24JvbmDZTnXzR3BNYpDCx4UxDWWLgIQEfPNbXupWAOotBH\nmzVcMCAcUDfUKyHHQv1qEVzWNlx0FvdiYB5PV4zcCGkTNSFTzVvEmJs0NOWDilF9\nfuJcP6QV1Iut+aiR56eJlEikmRpdJ/oVuTAp/0afxwKBgQC2G5EK/fbHcQqGZtXT\nSsd8o99hWG8LRdQNC0X+wgexr1j0LjxlL2FnqCAASZpa1LPF8+yxlDxz3dVHEBkC\nc/GBk6aGLlbVSBtprnD++7dnLeREJBRnD5nqo1uZwGyZ/Yrfveka635iehQc/RZb\nW0jNLt3Vnl6ipwRBhd1gIgp16w==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-no7tg@roadtoll-1.iam.gserviceaccount.com",
      "client_id": "101672616690548082132",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-no7tg%40roadtoll-1.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      //for using the firebase messaging service for push notifications
      "https://www.googleapis.com/auth/firebase.messaging",

      //for database services
      "https://www.googleapis.com/auth/firebase.database",

      //for emnail services
      "https://www.googleapis.com/auth/userinfo.email",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    //get the  access token

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();

    return credentials.accessToken.data;
  }

  static sendNotificationToSelectedDriver(String deviceToken,
      BuildContext context, String userServiceRequestId) async {
    final String serverAccessToken = await getAccessToken();
    // String endpointFirebaseClouMessaging =
    //     'https://fcm.googleapis.com/v1/projects/roadtoll-1/messages:send';

    String userLocationAddress = Provider.of<AppInfo>(context, listen: false)
        .userPickUpLocation!
        .locationName!
        .toString();

    Map dataMap = {
      "id": "1",
      "serviceID": userServiceRequestId,
      "click_action": "FLUTTER_NOTICFICATION_CLICK",
      "status": 'done',
    };

    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': serverAccessToken,
    };

    Map bodyNotification = {
      "body": "Userlocation: \n$userLocationAddress",
      "title": "New Service Request",
    };

    Map officalNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceToken,
    };

    var responseNotification = http.post(
      Uri.parse(
          "https://fcm.googleapis.com/v1/projects/roadtoll-1/messages:send"),
      headers: headerNotification,
      body: jsonEncode(officalNotificationFormat),
    );

    // data we want to send

    // final Map<String, dynamic> message = {
    //   'message': {
    //     //the device we want to send to
    //     "token": deviceToken,
    //     'notification': {
    //       'title': "Service Request From ${username}}",
    //       'body': "User Location :  $userLocationAddreass ",
    //     },
    //     'data': {
    //       "id": "1",
    //       'serviceID': userServiceRequest,
    //       'click_action': "FLUTTER_NOTICFICATION_CLICK",
    //       'status': 'done',
    //     }
    //   }
    // };

    // //finally sending the request

    // final http.Response response = await http.post(
    //   Uri.parse(endpointFirebaseClouMessaging),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer $serverAccessToken'
    //   },
    //   body: jsonEncode(message),
    // );

    // if (response.statusCode == 200) {
    //   print("Notification Sent");
    // } else {
    //   print("Failed to send notification :${response.statusCode}");
    // }
  }

  //static double calculateServiceAmount()

//   static sendNotificationToServiceProvider(
//       String deviceRegistrationToken, String userRideRequestId, context) async {
//     String destinationAddress = userDropOffAddress;

//     Map <String , String> headerNotification  = {
//       "Content-Type": " application/json",
//       "Authorization": ""
//     }
//   }
// }
}

class PushNotificationService {}
