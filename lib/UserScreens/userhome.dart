import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder2/geocoder2.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:googleapis/dataproc/v1.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/assitant_method.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/geofire_assistant.dart';
import 'package:onroadvehiclebreakdowwn/Info/app_info.dart';

import 'package:onroadvehiclebreakdowwn/UserScreens/drawerscreen.dart';
/*import 'package:onroadvehiclebreakdowwn/global/global.dart';*/
import 'package:location/location.dart' as loc;
import 'package:connectivity/connectivity.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/splashscreen.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/models/activeServiceProviders.dart';
import 'package:onroadvehiclebreakdowwn/models/directions.dart';
import 'package:onroadvehiclebreakdowwn/widgets/progress.dialog.dart';
import 'package:provider/provider.dart';

class Userhome extends StatefulWidget {
  const Userhome({Key? key}) : super(key: key);

  @override
  State<Userhome> createState() => _UserhomeState();
}

class _UserhomeState extends State<Userhome> {
  String themeforMap = "";
  final Completer<GoogleMapController> googleMapCompleteContoller = Completer();

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  bool _selectedIndex = false;

  bool darkTheme = true;

  String selectedVehicleType = "";

  double searchLocationContainerHeight = 220;
  double waitingLocationContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;
  double suggestedRidesContainerHeight = 0;

  GoogleMapController? newcontrollerGoogleMap;

  Position? userCurrentPosition;

  var geoLocation = Geolocator();

  double searchingServiceProviderContainerHeight = 0;

  String userRequestStatus = "";

  //\ StreamSubscription<DatabaseEvent>? tripRidesRequestInfoStreamSubscription

  String serviceRideStatus = "On their way";

  bool openNavigationDrawer = true;

  LocationPermission? _locationPermission;

  StreamSubscription<DatabaseEvent>? tripRidesRequestInfoStreamSubscription;

  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinateList = [];

  Set<Polyline> polyLineSet = {};

  Set<Marker> markersSet = {};

  Set<Circle> circlesSet = {};

  DatabaseReference? referenceRequest;

  List<ActiveServiceProviders> onlineNearbyServiceProviderList = [];

  void showSearchingServiceProviderContainer() {
    setState(() {
      searchingServiceProviderContainerHeight = 200;
    });
  }

  saveSelection(String selectedVehicleType) {
    //save ServiceRequest
    referenceRequest =
        FirebaseDatabase.instance.ref().child("All Service Requests").push();

    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;

    var destinationLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;

    Map originLocationMap = {
      //"key:value"
      "latitude": destinationLocation!.loactionLatitude.toString(),
      "longitude": destinationLocation.loactionLongitude.toString(),
    };

    Map destinationLocationMap = {
      //"key:value"
      "latitude": destinationLocation.loactionLatitude.toString(),
      "longitude": destinationLocation.loactionLongitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation!.locationName,
      "destinationAddress": destinationLocation.locationName,
      "serviceID": "waiting",
    };

    referenceRequest!.set(userInformationMap);

    tripRidesRequestInfoStreamSubscription =
        referenceRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }
      // if ((eventSnap.snapshot.value as Map)["car_details"] != null) {
      //   setState(() {
      //     driverCarDetails =
      //         (eventSnap.snapshot.value as Map)["car_details"].toString();
      //   });
      // }

      if ((eventSnap.snapshot.value as Map)["name"] != null) {
        setState(() {
          driverCarDetails =
              (eventSnap.snapshot.value as Map)["name"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["phone"] != null) {
        setState(() {
          driverCarDetails =
              (eventSnap.snapshot.value as Map)["phone"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        setState(() {
          userRequestStatus =
              (eventSnap.snapshot.value as Map)["status"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["ServiceProviderLocation"] !=
          null) {
        double driverCurrentPositionLat = double.parse((eventSnap.snapshot.value
                as Map)["ServiceProviderLocation"]["latitude"]
            .toString());

        double driverCurrentPositionLng = double.parse((eventSnap.snapshot.value
                as Map)["ServiceProviderLocation"]["longitude"]
            .toString());

        LatLng driverCurrentPositionLatLng =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        if (userRequestStatus == "accepted") {
          updateArrivalTimeToUser(driverCurrentPositionLatLng);
        }

        //status  = arrived

        if (userRequestStatus == "Service Provider has arrived") {
          setState(() {
            serviceRideStatus = "Service Provider has arrived";
          });
        }

        if (userRequestStatus == "ontrip") {
          updateReachingTime(driverCurrentPositionLatLng);
        }

        if (userRequestStatus == " ended") {
          if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
            double fareAmount = double.parse(
                (eventSnap.snapshot.value as Map)["fareAmount"].toString());

            // var response = await showDialog(
            //     context: context,
            //     builder: (BuildContext context) =>
            //     //  PayFareAmountDialog(
            //     //       fareAmount: fareAmount,
            //     //     )
            //         );
            var response = "";

            if (response == "Cash Paid") {
              if ((eventSnap.snapshot.value as Map)["serviceID"] != null) {
                String assignedServiceID =
                    (eventSnap.snapshot.value as Map)["serviceID"].toString();

                // Navgator.push(context, MaterialPageRoute(builder: (c) => {
                //   RateDriverScreen();
                // }));

                referenceRequest!.onDisconnect();
                tripRidesRequestInfoStreamSubscription!.cancel();
              }
            }
          }
        }
      }
    });

    onlineNearbyServiceProviderList = GeofireAssistant.activeServiceList;
    searchNearestOnlineDrivers(selectedVehicleType);
  }

  showAssignedServiceProviderInfo() {
    setState(() {
      waitingLocationContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverInfoContainerHeight = 200;
      suggestedRidesContainerHeight = 0;
      bottomPaddingOfMap = 200;
    });
  }

  Future<void> retrieveServiceProviderInfo(
      List<ActiveServiceProviders> onlineNearbyServiceProviderList) async {
    serviceProviderList.clear();
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("Service Providers");

    for (int i = 0; i < onlineNearbyServiceProviderList.length; i++) {
      await ref
          .child(onlineNearbyServiceProviderList[i].serviceId.toString())
          .once()
          .then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        serviceProviderList.add(driverKeyInfo);
        print("Service key Information: " + serviceProviderList.toString());
      });
    }
  }

//  onlineNearbyServiceProvidersList  = GeofireAssistant.activeServiceList;

  Future<void> searchNearestOnlineDrivers(String selectedVehicleType) async {
    if (onlineNearbyServiceProviderList.isEmpty) {
      // Cancel the service request if no service provider is available
      referenceRequest!.remove();

      setState(() {
        polyLineSet.clear();
        markersSet.clear();
        circlesSet.clear();
        pLineCoordinateList.clear();
      });

      Fluttertoast.showToast(msg: "No service Provider available ");
      Fluttertoast.showToast(msg: "Search again. \n Restarting App");

      Future.delayed(const Duration(milliseconds: 4000), () {
        referenceRequest!.remove();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const SplashScreen()));
      });
      return;
    } else {
      await retrieveServiceProviderInfo(onlineNearbyServiceProviderList);

      print(
          "Retrieved Service Provider Info: " + serviceProviderList.toString());

      for (var serviceProvider in serviceProviderList) {
        // Send in-app notification to service providers
        AssistantMethods.sendNotificationToSelectedDriver(
            serviceProvider["tokens"], context, referenceRequest!.key!);
      }

      Fluttertoast.showToast(msg: "Notification Sent ");
      showSearchingServiceProviderContainer();

      FirebaseDatabase.instance
          .ref()
          .child("All Ride Request")
          .child(referenceRequest!.key!)
          .child("serviceID")
          .onValue
          .listen((event) {
        print("Event : ${event.snapshot.value}");
        if (event.snapshot.value != null && event.snapshot.value != "waiting") {
          showAssignedServiceProviderInfo();
        }
      });
    }
  }

  String username = userModelCurrentInfo?.name ?? '';
  String userEmail = userModelCurrentInfo?.email ?? '';

  bool requestPositionInfo = true;

  //intializeGeofire();

  // AssistantMethods.readTripsKeysForOnlineUser(context);

  updateArrivalTimeToUser(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;
      LatLng userPickingPosition =
          LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionsDetails(
              driverCurrentPositionLatLng, userPickingPosition);

      if (directionDetailsInfo == null) {
        return;
      }
      setState(() {
        serviceRideStatus = " Service Provider On  The Way" +
            directionDetailsInfo.durationText.toString();
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTime(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;
      //not what you think
      var destinationFromUser =
          Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

      LatLng userDestinationPosition = LatLng(
          destinationFromUser!.loactionLatitude!,
          destinationFromUser.loactionLongitude!);

      var directionsDetailsInfo =
          await AssistantMethods.obtainOriginToDestinationDirectionsDetails(
              driverCurrentPositionLatLng, userDestinationPosition);

      if (directionsDetailsInfo == null) {
        return;
      }
      setState(() {
        serviceRideStatus = "Close to destination" +
            directionsDetailsInfo.durationText.toString();
      });

      requestPositionInfo = true;
    }
  }

  bool showMap = false;

  // bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  // String selectedVehicleType = "";

  Future<void> drawPolylineFromOriginToDestination(bool darkTheme) async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.loactionLatitude!, originPosition.loactionLongitude!);

    var destinationLatLng = LatLng(destinationPosition!.loactionLatitude!,
        destinationPosition.loactionLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait....",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionsDetails(
            originLatLng, destinationLatLng);

    setState(() {
      serviceDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();

    List<PointLatLng> decodePolylinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.ePoints!);

    pLineCoordinateList.clear();

    if (decodePolylinePointsResultList.isNotEmpty) {
      decodePolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinateList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.black54,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinateList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,
      );
      polyLineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;

    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.latitude > originLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      newcontrollerGoogleMap
          ?.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));
    });

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      infoWindow:
          InfoWindow(title: originPosition.locationName, snippet: 'Origin'),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: 'Destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  intializeGeoFireListener() {
    Geofire.initialize("activeService");

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);
      if (map != null) {
        var callback = map["callback"];
        switch (callback) {
          case Geofire.onKeyEntered:
            ActiveServiceProviders activeDrivers = ActiveServiceProviders();
            activeDrivers.locationLatitude = map["latitude"];
            activeDrivers.locationLongitude = map["longitude"];
            activeDrivers.serviceId = map["key"];
            GeofireAssistant.activeServiceList.add(activeDrivers);

            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;

          case Geofire.onKeyExited:
            GeofireAssistant.deletedOfflineDriverFromList(map["key"]);
            displayActiveDriversOnUsersMap();
            break;

          case Geofire.onKeyMoved:
            ActiveServiceProviders activeDrivers = ActiveServiceProviders();
            activeDrivers.locationLatitude = map["latitude"];
            activeDrivers.locationLongitude = map["longitude"];
            activeDrivers.serviceId = map["key"];
            GeofireAssistant.updateActiveLocation(activeDrivers);
            displayActiveDriversOnUsersMap();
            break;

          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }

      setState(() {});
    });
  }

  // getAddressFromLatLng() async {
  //   try {
  //     GeoData data = await Geocoder2.getDataFromCoordinates(
  //         latitude: pickLocation!.latitude,
  //         longitude: pickLocation!.longitude,
  //         googleMapApiKey: googleMapKey);

  //     setState(() {
  //       Directions userPickUpAddress = Directions();
  //       userPickUpAddress.loactionLatitude = pickLocation!.latitude;
  //       userPickUpAddress.loactionLongitude = pickLocation!.longitude;
  //       userPickUpAddress.locationName = data.address;
  //       _address = data.address;

  //       Provider.of<AppInfo>(context, listen: false)
  //           .updatePickUpLocationAddress(userPickUpAddress);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  checkLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  Position? currentPositionOfUser;

  locateUserPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = currentPosition;

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

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    intializeGeoFireListener();

    // AssistantMethods.readTripsKeysForOnlineUser(context);
  }

  getAddressFromLatlng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: googlesMapKey);
      setState(() {
        Directions userPickUpAddress = Directions();
        userPickUpAddress.loactionLatitude = pickLocation!.latitude;
        userPickUpAddress.loactionLongitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;
        // _address = data.address;
      });
    } catch (e) {
      print(e);
    }
  }

  createActiveNearbyDriverMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
          context,
          /* include size of image*/ size: Size(0.2, 0.2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/towin_edited.png')
          .then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context)
        .loadString('maps/standard_maps.json')
        .then((value) {
      setState(() {
        themeforMap = value;
      });
      checkLocationPermission();
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          showMap = true;
        });
      } else {
        setState(() {
          showMap = false;
        });
      }
    });
  }

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) => SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Vehicle Trouble ?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27,
                  ),
                ),
              ),
              const Text(
                "Select a service to continue",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(55, 10, 10, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _vehicleServiceBottomSheet(context));
                      },
                      child: SizedBox(
                        height: 75,
                        width: 60,
                        child: Image.asset(
                          'assets/R (2).png',
                          height: 75,
                          width: 60,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(120, 10, 10, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _vehicleServiceBottomSheet(context));
                      },
                      child: SizedBox(
                        height: 75,
                        width: 60,
                        child: Image.asset(
                          "assets/R (1).png",
                          height: 75,
                          width: 60,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _vehicleServiceBottomSheet(context));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            style: BorderStyle.none,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                        child: Text(
                          "Flat Tyre",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _vehicleServiceBottomSheet(context));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              style: BorderStyle.none,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(9.0, 0, 0, 0),
                          child: Text(
                            "Battery Emergency",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 30, 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _vehicleServiceBottomSheet(context));
                      },
                      child: SizedBox(
                        height: 75,
                        width: 60,
                        child: Image.asset(
                          "assets/R (3).png",
                          height: 75,
                          width: 60,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100, 0, 10, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _vehicleServiceBottomSheet(context));
                      },
                      child: SizedBox(
                        height: 75,
                        width: 60,
                        child: Image.asset(
                          "assets/download (10).jfif",
                          height: 75,
                          width: 60,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _vehicleServiceBottomSheet(context));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            style: BorderStyle.none,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Towing Emergency",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _vehicleServiceBottomSheet(context));
                      },
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _vehicleServiceBottomSheet(context));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              style: BorderStyle.none,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                          child: Text(
                            "Fuel Emergency",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
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

  Future _vehicleServiceBottomSheet(BuildContext context) {
    // Create a FocusNode to manage the focus of the TextFormField

    //final FocusNode towingPointFocusNode = FocusNode();
    // final FocusNode pickingPointFocusNode = FocusNode();

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => SizedBox(
        height: 800,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Picking Point ",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  Provider.of<AppInfo>(context)
                                              .userPickUpLocation !=
                                          null
                                      ? "${(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24)}..."
                                      : "Getting Address...",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 120,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 28,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                " Select Vehicle Type",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0, 0, 22.0, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVehicleType = "Two Wheeler";
                        });
                        // saveSelection();
                      },
                      child: Container(
                        color: selectedVehicleType == "Two Wheeler"
                            ? Colors.black
                            : Colors.white,
                        child: Image.asset(
                          "assets/Scooter-512.webp",
                          height: 90,
                          width: 90,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0, 0, 22.0, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVehicleType = "Four Wheeler";
                        });

                        // saveSelection();
                      },
                      child: Container(
                        color: selectedVehicleType == "Four Wheeler"
                            ? Colors.black
                            : Colors.white,
                        child: Image.asset(
                          "assets/off-road-car-4x4-512.webp",
                          height: 80,
                          width: 75,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0, 0, 22.0, 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVehicleType = " Heavy Wheeler";
                        });

                        // saveSelection();
                      },
                      child: Container(
                        color: selectedVehicleType == "Heavy Wheeler"
                            ? Colors.black
                            : Colors.white,
                        child: Image.asset(
                          "assets/truck.png",
                          height: 80,
                          width: 75,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 8, 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {});
                      // saveSelection();
                    },
                    child: SizedBox(
                      height: 60,
                      width: 110,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          // saveSelection();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedVehicleType == "Two Wheeler"
                              ? Colors.black
                              : Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          " Two Wheeler",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: selectedVehicleType == "Two Wheeler"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 8, 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {});
                      // saveSelection();
                    },
                    child: SizedBox(
                      height: 60,
                      width: 110,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {});

                          // saveSelection();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedVehicleType == "Four Wheeler"
                              ? Colors.black
                              : Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          " Four Wheeler",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: selectedVehicleType == "Four Wheeler"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 8, 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {});
                      // saveSelection();
                    },
                    child: SizedBox(
                      height: 60,
                      width: 110,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedVehicleType == "Heavy Wheeler"
                                  ? Colors.black
                                  : Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          " Heavy Wheeler",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: selectedVehicleType == "Heavy Wheeler"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () {
                  //   Fluttertoast.showToast(
                  //       msg: "Please select a vehicle from above");
                  // }
                  setState(() {
                    // searchNearestOnlineDrivers();
                    saveSelection(selectedVehicleType);
                    // searchingServiceProviderContainerHeight = 400;
                  });
                },
                style: ElevatedButton.styleFrom(
                    elevation: 2,
                    fixedSize: const Size(350, 60),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(style: BorderStyle.solid))),
                child: const Text(
                  "Find Service",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  createActiveNearbyDriverMarker();
    return Scaffold(
      key: _scaffoldState,
      drawer: DrawerScreen(),
      body: Stack(
        children: [
          showMap
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No Internet connection",
                      style: TextStyle(fontSize: 20),
                    ),
                    Image.asset(
                        "assets/internet-day-concept-illustration_114360-5303.avif")
                  ],
                )
              : GoogleMap(
                  padding: EdgeInsets.only(top: 30, bottom: bottomPaddingOfMap),
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  polylines: polyLineSet,
                  circles: circlesSet,
                  markers: markersSet,
                  initialCameraPosition: googlePlexIntitialPosition,
                  onMapCreated: (GoogleMapController mapContoller) {
                    googleMapCompleteContoller.complete(mapContoller);
                    newcontrollerGoogleMap = mapContoller;
                    locateUserPosition();

                    setState(() {});
                  },
                  onCameraMove: (CameraPosition? position) {
                    if (pickLocation != position!.target) {
                      setState(() {
                        pickLocation = position.target;
                      });
                    }
                  },
                  onCameraIdle: () {
                    getAddressFromLatlng();
                  },
                ),
          // Align(
          //   alignment: Alignment.center,
          //   child: Padding(
          //     padding: const EdgeInsets.only(bottom: 35),
          //     child: Image.asset(
          //       "assets/loca_2.png",
          //       height: 45,
          //       width: 45,
          //     ),
          //   ),
          // ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  _scaffoldState.currentState!.openDrawer();
                  // widget._scaffoldState.currentState!.openDrawer();
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Container(
          //     width: 50,
          //     height: 50,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(25),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.3),
          //           blurRadius: 5,
          //           spreadRadius: 0,
          //         ),
          //       ],
          //     ),
          //     child: IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => const UserProfile(),
          //           ),
          //         );
          //       },
          //       icon: const Icon(
          //         Icons.menu,
          //         size: 30,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: searchingServiceProviderContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const LinearProgressIndicator(
                    color: Colors.green,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      "Searching For Service Provider...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      referenceRequest!.remove();
                      setState(() {
                        searchLocationContainerHeight = 0;
                        suggestedRidesContainerHeight = 0;
                        searchingServiceProviderContainerHeight = 0;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    child: const Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 60,
            left: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                color: Colors.black,
                height: 80,
                width: 80,
                child: FloatingActionButton(
                  onPressed: () {
                    _displayBottomSheet(context);
                  },
                  backgroundColor: Colors.black,
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 90, 228, 168),
                    size: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  displayActiveDriversOnUsersMap() {
    setState(() {
      markersSet.clear();
      circlesSet.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();

      for (ActiveServiceProviders eachDriver
          in GeofireAssistant.activeServiceList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.serviceId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );
        driversMarkerSet.add(marker);

        setState(() {
          markersSet = driversMarkerSet;
        });
      }
    });
  }
}
