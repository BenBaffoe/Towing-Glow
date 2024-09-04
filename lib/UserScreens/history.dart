import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/serviceinfo.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/serviceproviderinfo.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/models/historyinfo.dart';

class History extends StatefulWidget {
  final Historyinfo? userHistory;

  History({
    super.key,
    required this.userHistory,
  });

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("userInfo");
  List<ServiceInfo> serviceInfoList = [];
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userId;
  String? service;
  String? userLocation;

  DatabaseReference userRefs =
      FirebaseDatabase.instance.ref().child("serviceProvider");

  @override
  void initState() {
    super.initState();
    _fetchServiceProviderData();
    _fetchUserData();
  }

  void _fetchServiceProviderData() {
    userRefs.onValue.listen((event) {
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

              setState(() {
                serviceInfoList.add(ServiceInfo(
                  serivceProviderLocationAddress: originAddress,
                  serivceProviderName: name,
                  serivceProviderPhone: phone,
                  service: service,
                  time: time,
                ));
              });
            }
          }
        });
      }
    });
  }

  void _fetchUserData() {
    userRef.child(firebaseAuth.currentUser!.uid).onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          userName = userData['name'] ?? '';
          userEmail = userData['email'] ?? '';
          userPhone = userData['phone'] ?? '';
          userId = userData['id'] ?? '';
          service = userData['service'] ?? '';
          userPhone = userData['phone'] ?? '';
          userLocation = userData['originAddress'] ?? '';
        });
      }
    });
  }

  void _deleteServiceInfo(int index) {
    setState(() {
      serviceInfoList.removeAt(index);
    });
  }

  void _deleteAllServiceInfo() {
    setState(() {
      serviceInfoList.clear();
    });
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Service'),
          content: Text('Are you sure you want to delete this service?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteServiceInfo(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        leading: Icon(Icons.arrow_back_ios),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteAllServiceInfo,
          ),
        ],
      ),
      body: serviceInfoList.isEmpty
          ? const Center(child: Text("Nothing To See Here"))
          : ListView.builder(
              itemCount: serviceInfoList.length,
              itemBuilder: (context, index) {
                final serviceInfo = serviceInfoList[index];
                return GestureDetector(
                  onTap: () => _showDeleteDialog(index),
                  child: Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userHistory?.userName ?? 'Unknown User',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Service Request: ${serviceInfo.service ?? 'N/A'}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Service Provider: ${serviceInfo.serivceProviderName ?? 'Unknown'}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
