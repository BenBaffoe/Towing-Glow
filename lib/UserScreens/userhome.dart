import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder2/geocoder2.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis/biglake/v1.dart';
// import 'package:googleapis/dataproc/v1.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/assitant_method.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/geofire_assistant.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/serviceproviderinfo.dart';
import 'package:onroadvehiclebreakdowwn/Info/app_info.dart';

import 'package:onroadvehiclebreakdowwn/UserScreens/drawerscreen.dart';
/*import 'package:onroadvehiclebreakdowwn/global/global.dart';*/
import 'package:location/location.dart' as loc;
import 'package:connectivity/connectivity.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/localNotification.dart';

import 'package:onroadvehiclebreakdowwn/UserScreens/serviceproviderlocaton.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/splashscreen.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/main.dart';
import 'package:onroadvehiclebreakdowwn/models/activeServiceProviders.dart';
import 'package:onroadvehiclebreakdowwn/models/directions.dart';
import 'package:onroadvehiclebreakdowwn/models/retrievedata.dart';
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

  double searchLocationContainerHeight = 220;
  double waitingLocationContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;
  double suggestedRidesContainerHeight = 0;

  GoogleMapController? newcontrollerGoogleMap;

  Position? userCurrentPosition;

  var geoLocation = Geolocator();

  double searchingServiceProviderContainerHeight = 0;

  String userRequestStatus = "";

  String selectedVehicleType = "Two Wheeler";

  bool showLoad = false;

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

  ServiceProviderInfo? serviceProviderInformation;

  String? _requestId;
  Timer? _timer;

  void showSearchingServiceProviderContainer() {
    setState(() {
      searchingServiceProviderContainerHeight = 800;
    });
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

  // }

  String serviceType = '';
  String userEmail = '';
  String userPhone = '';
  String userId = '';
  String service = '';
  String userName = '';

  Future<void> selectService(
      String serviceType, String selectedVehicleType) async {
    // Initialize referenceRequest and userRef
    referenceRequest =
        FirebaseDatabase.instance.ref().child("Service Requests").push();
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("userInfo");

    // Get user data from Firebase
    userRef.child(firebaseAuth.currentUser!.uid).onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        userName = userData['name'] ?? '';
        userEmail = userData['email'] ?? '';
        userPhone = userData['phone'] ?? '';
        userId = userData['id'] ?? '';
        service = userData['service'] ?? '';

        var originLocation =
            Provider.of<AppInfo>(context, listen: false).userPickUpLocation;

        Map originLocationMap = {
          "latitude": originLocation?.locationLatitude,
          "longitude": originLocation?.locationLongitude,
        };

        Map userInformationMap = {
          "origin": originLocationMap,
          "time": DateTime.now().toString(),
          "userName": userName,
          "userPhone": userPhone,
          "originAddress": originLocation!.locationName,
          "serviceID": "waiting",
          "service": serviceType,
          "vehicleType": selectedVehicleType,
          "serviceId": "first",
        };
        referenceRequest!.set(userInformationMap);

        print("$userName + osididsiididjsfjsdjsdjsdjsdjsdjsdjsdjsdjsdjsdj");

        print(
            "$originLocationMap + fhfhfhfhfhfhfhhhhhhhhhhhhhhhhhhhhsjkkkkkkkkkkkkkkkkkkkkkkkkk");
      } else {
        print("No user data found.");
      }
    });

    // Ensure originLocation is not null

    // if (originLocation == null) {
    //   print("Error: originLocation is null.");
    //   return;
    // }

    // // Map for origin location

    // // Ensure userName and other fields are not null
    // if (userName == null ||
    //     userPhone == null ||
    //     originLocation.locationName == null) {
    //   print("Error: One or more user fields are null.");
    //   return;
    // }

    // Map for user information

    // Set data in Firebase
  }

  void findService() {}

  // String userName = userModelCurrentInfo?.name ?? '';
  // String userEmail = userModelCurrentInfo?.email ?? '';
  Retrievedata? userHistory;

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
          destinationFromUser!.locationLatitude!,
          destinationFromUser.locationLongitude!);

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
  bool isLoading = false;

  // bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  Future<void> retrieveServiceRequest(String serviceType) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("serviceProvider");

    userRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> serviceRequestsMap =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        serviceRequestsMap.forEach((key, value) {
          Map<dynamic, dynamic> serviceProviderInfo =
              Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);
          String? service = serviceProviderInfo['service'] as String?;
          String? name = serviceProviderInfo['name'] as String?;
          String? phone = serviceProviderInfo['phone'] as String?;
          String? originAddress =
              serviceProviderInfo['originAddress'] as String?;
          String? time = serviceProviderInfo['time'] as String?;

          // Check if 'location' exists and has valid latitude and longitude
          if (serviceProviderInfo.containsKey('location') &&
              serviceProviderInfo['location'] != null) {
            Map<dynamic, dynamic> origin = Map<dynamic, dynamic>.from(
                serviceProviderInfo['location'] as Map<dynamic, dynamic>);

            if (origin.containsKey('latitude') &&
                origin.containsKey('longitude') &&
                origin['latitude'] != null &&
                origin['longitude'] != null) {
              double originLatitude =
                  double.tryParse(origin['latitude'].toString()) ?? 0.0;
              double originLongitude =
                  double.tryParse(origin['longitude'].toString()) ?? 0.0;
              LatLng originLatLng = LatLng(originLatitude, originLongitude);

              print(
                  "$originLatLng + solankiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii ");

              if (serviceType == service) {
                serviceProviderInformation = ServiceProviderInfo(
                  serivceProviderLocation: originLatLng,
                  serivceProviderName: name,
                  serivceProviderPhone: phone,
                  serivceProviderLocationAddress: originAddress,
                  time: time,
                );
                // Retrieve the service request info
                LocalNotifications.showSimpleNotification(
                  title: 'Service Request Accepted',
                  body: 'Service Provider $name is on their way',
                  payload: "$name on the way $service\nPhone: $phone",
                );
              }
            } else {
              print('Invalid latitude or longitude in location map.');
            }
          } else {
            print('Location information is missing or null.');
          }
        });
      } else {
        print('No service provider data available.');
      }
    });
  }

  void startPeriodicServiceRequestRetrieval() {
    // Define the timer duration
    const duration = Duration(seconds: 30);

    // Set up a timer that triggers every 'duration'
    Timer.periodic(duration, (Timer timer) {
      // Call your existing data retrieval function
      retrieveServiceRequest(serviceType);
    });
  }

  // String selectedVehicleType = "";

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
            activeDrivers.id = map["key"];
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
            activeDrivers.id = map["key"];
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

  void getNotification() async {
    print("Listening for notifications");

    LocalNotifications.onClickedNotification.stream.listen((event) {
      // Check if serviceProviderInformation is null
      if (serviceProviderInformation != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Serviceproviderlocation(
                serviceProviderInfo: serviceProviderInformation,
                payload: event,
              ),
            ),
          );
        });
        print(serviceProviderInformation!.serivceProviderLocation);
        print(serviceProviderInformation!.serivceProviderPhone);
        print(serviceProviderInformation!.serivceProviderName);
        print(
            "---------------------------------------------------------------------");
      } else {
        print(
            "ServiceProviderInformation is null. Cannot navigate. $serviceProviderInformation");
      }
    });
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
        googleMapApiKey: googlesMapKey,
      );
      setState(() {
        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = pickLocation!.latitude;
        userPickUpAddress.locationLongitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;
        // _address = data.address;

        Provider.of<AppInfo>(context, listen: false)
            .updatePickUpLocationAddress(userPickUpAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  createActiveNearbyDriverMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
          context,
          /* include size of image*/ size: const Size(48, 48));
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/towin.jpeg')
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
      createActiveNearbyDriverMarker();
      LocalNotifications.init();
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
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
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
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                serviceType = "Vulcanizer";
                              });
                              Navigator.pop(context);
                              _vehicleServiceBottomSheet(context);
                            },
                            child: Image.asset(
                              "assets/red-pump-inflates-car-wheel_124715-2293.avif",
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            serviceType = "Vulcanizer";
                          });
                          Navigator.pop(context);
                          _vehicleServiceBottomSheet(context);
                        },
                        child: const Text(
                          "Flat Tyre",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 130,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                serviceType = "Fuel/Battery Emergency";
                              });
                              Navigator.pop(context);
                              _vehicleServiceBottomSheet(context);
                            },
                            child: Image.asset(
                              "assets/battery-icon-cartoon-illustration-battery-vector-icon-web_96318-30803.avif",
                              width: 80,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            serviceType = "Fuel/Battery Emergency";
                          });
                          Navigator.pop(context);
                          _vehicleServiceBottomSheet(context);
                        },
                        child: const Text(
                          "Battery Issue",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                serviceType = "Towing Emergency";
                              });
                              Navigator.pop(context);
                              _vehicleServiceBottomSheet(context);
                            },
                            child: Image.asset(
                              "assets/truck-picking-up-car-road-service-vehicle_533410-2461.avif",
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            serviceType = "Towing Emergency";
                          });
                          Navigator.pop(context);
                          _vehicleServiceBottomSheet(context);
                        },
                        child: const Text(
                          "Towing emergency",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                serviceType = "Fuel/Battery Emergency";
                              });
                              Navigator.pop(context);
                              _vehicleServiceBottomSheet(context);
                            },
                            child: Image.asset(
                              "assets/gas-station-cartoon-icon-illustration_138676-2605.avif",
                              width: 80,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            serviceType = "Fuel/Battery Emergency";
                          });
                          Navigator.pop(context);
                          _vehicleServiceBottomSheet(context);
                        },
                        child: const Text(
                          "Fuel emergency",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _searchServiceBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false, // Prevent dismissal by tapping outside
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      barrierColor: Colors.transparent,
      builder: (context) {
        Future.delayed(const Duration(seconds: 28), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context); // Automatically close after 40 seconds
          }
        });

        return Container(
          height: 400,
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
                  "Waiting For A Service Provider...",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/Towing.gif",
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  referenceRequest!.remove();
                  setState(() {
                    searchLocationContainerHeight = 0;
                    suggestedRidesContainerHeight = 0;
                    searchingServiceProviderContainerHeight = 0;
                  });
                  Navigator.pop(context); // Manually close on tap
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(width: 4, color: Colors.green),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 300,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Manually close on tap
                  },
                  child: const Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehicleOption(
    String vehicleType,
    String assetPath,
    Color bgColor,
    Color textColor,
    StateSetter setModalState,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          setModalState(() {
            selectedVehicleType = vehicleType;
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: bgColor,
            child: Column(
              children: [
                Image.asset(
                  assetPath,
                  height: 80,
                  width: 85,
                ),
                Text(
                  vehicleType,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _feeBottomSheet(BuildContext context) {
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
        height: 300,
        child: Column(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Are you sure you want a service ?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Text(
                      "Service request will not be cancelled once  you  find a service",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 1,
                ),
                const Column(children: [
                  Text(
                      "Service prices may range from as low as GHS 10  -  GHS 210"),
                ]),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Future.delayed(const Duration(seconds: 2));

                      if (context != null) {
                        Navigator.pop(context);
                      } else {
                        print('Context is null');
                        return;
                      }

                      // startPeriodicServiceRequestRetrieval();

                      // Add a delay of 2 seconds
                      if (mounted) {
                        _searchServiceBottomSheet(context).then((_) {
                          retrieveServiceRequest(serviceType).then((_) {
                            getNotification();
                            selectService(serviceType, "O");
                          });
                        }).catchError((e) {
                          print('Error in showing bottom sheet: $e');
                        });
                      }
                    } catch (e) {
                      print('Error: $e'); // Print any errors for debugging
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    fixedSize: const Size(350, 60),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(style: BorderStyle.solid),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          strokeWidth: 1,
                        )
                      : const Text(
                          "Confirm Request",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                )
              ],
            )
          ],
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
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: 400,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(35, 0, 0, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        Provider.of<AppInfo>(context)
                                                    .userPickUpLocation !=
                                                null
                                            ? (Provider.of<AppInfo>(context)
                                                        .userPickUpLocation!
                                                        .locationName!)
                                                    .substring(0, 14) +
                                                "..."
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildVehicleOption(
                          "Two Wheeler",
                          "assets/green-scooter_1308-84081.avif",
                          selectedVehicleType == "Two Wheeler"
                              ? Colors.black
                              : Colors.white,
                          selectedVehicleType == "Two Wheeler"
                              ? Colors.white
                              : Colors.black,
                          setModalState,
                        ),
                        _buildVehicleOption(
                          "Four Wheeler",
                          "assets/car-2026848_1280.png",
                          selectedVehicleType == "Four Wheeler"
                              ? Colors.black
                              : Colors.white,
                          selectedVehicleType == "Four Wheeler"
                              ? Colors.white
                              : Colors.black,
                          setModalState,
                        ),
                        _buildVehicleOption(
                          "Heavy Wheeler",
                          "assets/trash-truck-white-background_1308-24888.avif",
                          selectedVehicleType == "Heavy Wheeler"
                              ? Colors.black
                              : Colors.white,
                          selectedVehicleType == "Heavy Wheeler"
                              ? Colors.white
                              : Colors.black,
                          setModalState,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _feeBottomSheet(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        fixedSize: const Size(350, 60),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(style: BorderStyle.solid),
                        ),
                      ),
                      child: const Text(
                        "Find Service",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //  createActiveNearbyDriverMarker();
    return Scaffold(
      key: _scaffoldState,
      drawer: DrawerScreen(
        serviceProviderInfo: serviceProviderInformation,
      ),
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
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              child: GestureDetector(
                onTap: () {
                  // _scaffoldState.currentState!.openDrawer();
                  _scaffoldState.currentState!.openDrawer();
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
          ),
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
          markerId: MarkerId(eachDriver.id!),
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
