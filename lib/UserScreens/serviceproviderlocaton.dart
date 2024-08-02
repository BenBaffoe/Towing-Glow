import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/assitant_method.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/serviceproviderinfo.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/main.dart';
import 'package:onroadvehiclebreakdowwn/models/directions_details_info.dart';

class Serviceproviderlocation extends StatefulWidget {
  final ServiceProviderInfo? serviceProviderInfo;
  final String? payload;

  const Serviceproviderlocation({
    Key? key,
    required this.payload,
    required this.serviceProviderInfo,
  }) : super(key: key);

  @override
  State<Serviceproviderlocation> createState() =>
      _ServiceproviderlocationState();
}

class _ServiceproviderlocationState extends State<Serviceproviderlocation> {
  final Completer<GoogleMapController> googleMapCompleteController =
      Completer<GoogleMapController>();

  String distance = "";
  String duration = "";

  GoogleMapController? controllerGoogleMap;
  LatLng? serviceProviderLocation;
  Map<PolylineId, Polyline> polylines = {};
  Position? serviceCurrentPosition;
  LatLng? driverPosition;

  Future<void> _cameraPosition(LatLng pos) async {
    final GoogleMapController controller =
        await googleMapCompleteController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'location_channel_id',
      'Location Channel',
      channelDescription: 'Channel for location notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Service Provider Has Arrived!',
      'Call',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> locateServicePosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    serviceCurrentPosition = currentPosition;

    LatLng latLngPosition = LatLng(
        serviceCurrentPosition!.latitude, serviceCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            serviceCurrentPosition!, context);

    _updateDriverPosition(latLngPosition); // Update driverPosition here
    print('Service current position located: $latLngPosition');
  }

  void _handleSameLocation() {
    if (driverPosition != null &&
        serviceProviderLocation != null &&
        driverPosition!.latitude == serviceProviderLocation!.latitude &&
        driverPosition!.longitude == serviceProviderLocation!.longitude) {
      // Show notification if the locations are the same
      _showNotification();

      // Add a small offset to service provider's location to prevent repeated notifications
      serviceProviderLocation = LatLng(
        serviceProviderLocation!.latitude + 0.001,
        serviceProviderLocation!.longitude + 0.001,
      );
    }
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    serviceProviderLocation =
        widget.serviceProviderInfo!.serivceProviderLocation;

    _handleSameLocation();

    if (driverPosition == null || serviceProviderLocation == null) {
      print('Driver position or Service Provider location is null');
      return [];
    }

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googlesMapKey,
      PointLatLng(driverPosition!.latitude, driverPosition!.longitude),
      PointLatLng(serviceProviderLocation!.latitude,
          serviceProviderLocation!.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }

    return polylineCoordinates;
  }

  void _updateDriverPosition(LatLng position) {
    setState(() {
      driverPosition = position;
      _cameraPosition(driverPosition!);
    });
  }

  Future _showServiceProviderInfo() async {
    _getDistanceAndTime();
    return showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      builder: (context) => GestureDetector(
        onTap: () {
          // Navigator.of(context, rootNavigator: true).pop();
        },
        child: Container(
          color: Colors.white,
          height: 320,
          child: Column(
            children: [
              const LinearProgressIndicator(color: Colors.green),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "Service Provider Arriving in....",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$duration", // Show duration here
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: Row(
                  children: [
                    const Text(
                      "Distance remaining: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      distance.substring(0, 4) + " Km", // Show distance here
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 1,
                ),
              ),
              Card(
                color: Colors.white,
                child: Row(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 50),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              "assets/pensioner-man-with-medical-mask-is-driving-red-car-foreground-vector-flat-illustration_531064-1742.jpg",
                              height: 75,
                              width: 75,
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 40, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.serviceProviderInfo!.serivceProviderName!}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "0${widget.serviceProviderInfo!.serivceProviderPhone!}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Click on the menu icon and select payments to \n make payment to the service provider",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

    locateServicePosition().then((_) {
      getPolylinePoints().then((coordinates) {
        if (coordinates.isNotEmpty) {
          generatePolylineFromPoints(coordinates);
        }
      });
    });
    // Ensure this is called after locateServicePosition
  }

  LatLng start = LatLng(37.8253948, -122.3038929);

  LatLng end = LatLng(37.8253948, -122.3038929);

  Future<void> _getDistanceAndTime() async {
    if (widget.serviceProviderInfo != null &&
        widget.serviceProviderInfo!.serivceProviderLocation != null) {
      serviceProviderLocation =
          widget.serviceProviderInfo!.serivceProviderLocation;
    } else {
      print("Service provider info or location is null");
    }

    if (serviceProviderLocation != null && driverPosition != null) {
      _handleSameLocation();

      DirectionsDetailsInfo? directions =
          await AssistantMethods.obtainOriginToDestinationDirectionsDetails(
        driverPosition!,
        serviceProviderLocation!,
      );

      if (directions != null) {
        setState(() {
          distance = directions.distanceText!;
          duration = directions.durationText!;
        });
        print('Distance: $distance, Duration: $duration');
      } else {
        setState(() {
          distance = 'N/A';
          duration = 'N/A';
        });
        print('Directions not available');
      }

      print('Driver Position: $driverPosition');
      print('Service Provider Location: $serviceProviderLocation');
    } else {
      print("Driver position or Service provider location is null");
    }
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
              if (driverPosition != null)
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: driverPosition!,
                  icon: BitmapDescriptor.defaultMarker,
                ),
              if (serviceProviderLocation != null)
                Marker(
                  markerId: MarkerId(
                      widget.serviceProviderInfo!.serivceProviderName!),
                  position: serviceProviderLocation!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                ),
            },
            polylines: Set<Polyline>.of(polylines.values),
            initialCameraPosition: CameraPosition(
              target: LatLng(37.43296265331129, -122.08832357078792),
              zoom: 10,
            ),
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              googleMapCompleteController.complete(mapController);
              locateServicePosition();

              setState(() {});
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                _showServiceProviderInfo();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 90, 228, 168)),
              child: Text(
                "Show Service Provider Info ",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
