// import 'dart:async';
// import 'package:geocoder2/geocoder2.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:location/location.dart' as loc;
// import 'package:onroadvehiclebreakdowwn/Assistants/assitant_method.dart';
// import 'package:onroadvehiclebreakdowwn/Info/app_info.dart';
// import 'package:onroadvehiclebreakdowwn/global/global.dart';
// import 'package:onroadvehiclebreakdowwn/models/directions.dart';
// import 'package:provider/provider.dart';

// class PreciseLocation extends StatefulWidget {
//   const PreciseLocation({super.key});

//   @override
//   State<PreciseLocation> createState() => _PreciseLocationState();
// }

// class _PreciseLocationState extends State<PreciseLocation> {
//   final Completer<GoogleMapController> googleMapCompleteContoller =
//       Completer<GoogleMapController>();

//   GoogleMapController? controllerGoogleMap;

//   double bottomPaddingOfMap = 0;

//   GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

//   loc.Location location = loc.Location();
//   LatLng? pickLocation;

//   Position? userCurrentPosition;

//   String? _address;

//   getAddressFromLatLng() async {
//     try {
//       GeoData data = await Geocoder2.getDataFromCoordinates(
//           latitude: pickLocation!.latitude,
//           longitude: pickLocation!.longitude,
//           googleMapApiKey: googlesMapKey);

//       setState(() {
//         Directions userPickUpAddress = Directions();
//         userPickUpAddress.loactionLatitude = pickLocation!.latitude;
//         userPickUpAddress.loactionLongitude = pickLocation!.longitude;
//         userPickUpAddress.locationName = data.address;

//         // _address = data.address;

//         Provider.of<AppInfo>(context, listen: false)
//             .updatePickUpLocationAddress(userPickUpAddress);
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   static const CameraPosition googlePlexIntitialPosition = CameraPosition(
//       bearing: 244.64,
//       target: LatLng(6.6833, -1.6163),
//       tilt: 59.440717697143555,
//       zoom: 13.151926040649414);

//   locateUserPosition() async {
//     Position currentPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     userCurrentPosition = currentPosition;

//     LatLng latLngPosition =
//         LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
//     CameraPosition cameraPosition =
//         CameraPosition(target: latLngPosition, zoom: 15);

//     controllerGoogleMap!
//         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

//     String humanReadableAddress =
//         await AssistantMethods.searchAddressForGeographicCoOrdinates(
//             userCurrentPosition!, context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.normal,
//             myLocationButtonEnabled: true,
//             zoomGesturesEnabled: true,
//             zoomControlsEnabled: true,
//             initialCameraPosition: googlePlexIntitialPosition,
//             onMapCreated: (GoogleMapController mapContoller) {
//               controllerGoogleMap = mapContoller;
//               googleMapCompleteContoller.complete(controllerGoogleMap);
//               locateUserPosition();
//               setState(() {
//                 bottomPaddingOfMap = 200;
//               });
//             },
//             // onCameraMove: (CameraPosition? position) {
//             //   if (pickLocation != position!.target) {
//             //     setState(() {
//             //       pickLocation = position.target;
//             //     });
//             //   }
//             // },
//             onCameraIdle: () {
//               getAddressFromLatLng();
//             },
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
//               child: Image.asset(
//                 "assets/loca_2.png",
//                 height: 45,
//                 width: 45,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
