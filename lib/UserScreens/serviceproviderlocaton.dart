import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/assitant_method.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/serviceproviderinfo.dart';
import 'package:onroadvehiclebreakdowwn/Info/app_info.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/models/directions_details_info.dart';
import 'package:provider/provider.dart';

class Serviceproviderlocation extends StatefulWidget {
  final ServiceProviderInfo? serviceProviderInfo;
  final String? payload;

  const Serviceproviderlocation(
      {super.key, required this.serviceProviderInfo, required this.payload});

  @override
  State<Serviceproviderlocation> createState() =>
      _ServiceproviderlocatonState();
}

class _ServiceproviderlocatonState extends State<Serviceproviderlocation> {
  final Completer<GoogleMapController> googleMapCompleteController =
      Completer<GoogleMapController>();

  GoogleMapController? newcontrollerGoogleMap;

  LatLng? userLocation;
  Map<PolylineId, Polyline> polylines = {};
  Position? userCurrentPosition;

  BitmapDescriptor? carIcon;

  var originLatLng;
  var originPosition;

  Future<void> _cameraPosition(LatLng pos) async {
    final GoogleMapController controller =
        await googleMapCompleteController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  locateUserPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = currentPosition;

    originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;

    originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    newcontrollerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            userCurrentPosition!, context);
    print("This is our address = $humanReadableAddress");

    // intializeGeoFireListener();

    // AssistantMethods.readTripsKeysForOnlineUser(context);
  }

  // Future<void> locateServicePosition() async {
  //   Position currentPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   serviceCurrentPosition = currentPosition;

  //   LatLng latLngPosition = LatLng(
  //       serviceCurrentPosition!.latitude, serviceCurrentPosition!.longitude);
  //   CameraPosition cameraPosition =
  //       CameraPosition(target: latLngPosition, zoom: 15);

  //   controllerGoogleMap!
  //       .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  //   String humanReadableAddress =
  //       await AssistantMethods.searchAddressForGeographicCoOrdinates(
  //           serviceCurrentPosition!, context);

  //   _updateDriverPosition(latLngPosition);
  // }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    userLocation = originLatLng;

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googlesMapKey,
      PointLatLng(originPosition!.latitude, originPosition!.longitude),
      PointLatLng(userLocation!.latitude, userLocation!.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(
          "$result.errorMessage + yooooooooooooooooooooooooyoyooooooooooooooooyoyooooooooooooooyoyooo");
    }

    print('originPosition: $originPosition');
    print('originLatLng: $originLatLng');
    print(
        'serviceProviderLocation: ${widget.serviceProviderInfo!.serivceProviderLocation}');

    return polylineCoordinates;
  }

  LatLng? serviceProviderLocation;
  // void _updateDriverPosition(LatLng position) {
  //   setState(() {
  //     driverPosition = position;
  //     // serviceProviderLocation = driverPosition;
  //     _cameraPosition(driverPosition!);
  //   });
  // }

  String distance = "";
  String duration = "";

  Future<void> _getDistanceAndTime() async {
    setState(() {
      serviceProviderLocation =
          widget.serviceProviderInfo!.serivceProviderLocation!;
    });

    DirectionsDetailsInfo? directions =
        await AssistantMethods.obtainOriginToDestinationDirectionsDetails(
      originLatLng,
      serviceProviderLocation!,
    );

    if (directions != null) {
      setState(() {
        distance = directions.distanceText!;
        duration = directions.durationText!;
      });
    } else {
      setState(() {
        distance = 'N/A';
        duration = 'N/A';
      });
    }

    print('originPosition: $originPosition');
    print('originLatLng: $originLatLng');
    print(
        'serviceProviderLocation: ${widget.serviceProviderInfo!.serivceProviderLocation}');
  }

  LatLng googlePlexInitialPosition =
      LatLng(37.43296265331129, -122.08832357078792);

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(4, 4)), // specify the size
      'assets/sports-car-303765_1280.png', // specify the asset path
    ).then((icon) {
      setState(() {
        carIcon = icon;
      });
    });

    _getDistanceAndTime();

    locateUserPosition().then((_) {
      getPolylinePoints().then((coordinates) {
        if (coordinates.isNotEmpty) {
          generatePolylineFromPoints(coordinates);
        }
      });

      _showServiceProviderInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(top: 40),
            mapType: MapType.normal,
            myLocationEnabled: true,
            markers: {
              if (userCurrentPosition != null)
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: originLatLng!,
                  icon: BitmapDescriptor.defaultMarker,
                ),
              if (widget.serviceProviderInfo!.serivceProviderLocation != null)
                Marker(
                  markerId: MarkerId(
                      widget.serviceProviderInfo!.serivceProviderName!),
                  position: serviceProviderLocation!,
                  icon: carIcon!,
                ),
            },
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: googlePlexInitialPosition,
              zoom: 10,
            ),
            onMapCreated: (GoogleMapController mapController) {
              newcontrollerGoogleMap = mapController;
              googleMapCompleteController.complete(mapController);
              locateUserPosition();
            },
          ),
        ],
      ),
    );
  }

  Future _showServiceProviderInfo() {
    return showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (context) => SizedBox(
        height: 380,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const LinearProgressIndicator(
              color: Colors.green,
            ),
            Row(
              children: [
                Text(
                  "Service Provider Arriving in....",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "$distance",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Distance remaining:",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "$duration",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/download (8).jfif",
                    height: 95,
                    width: 95,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      widget.serviceProviderInfo!.serivceProviderName!,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    Text(
                      widget.serviceProviderInfo!.serivceProviderPhone!,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
