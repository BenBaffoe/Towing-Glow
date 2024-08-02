import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onroadvehiclebreakdowwn/UserScreens/paymentscreen.dart';
import 'package:onroadvehiclebreakdowwn/models/paymodel.dart';

class Payment_Screen extends StatefulWidget {
  const Payment_Screen({super.key});

  @override
  State<Payment_Screen> createState() => _Payment_ScreenState();
}

class _Payment_ScreenState extends State<Payment_Screen> {
  Paymodel? _paymodel;

  Future<void> retrievePaymentStats() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("paymentStatus");
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
          String? jobState = serviceProviderInfo['jobStatus'] as String?;

          if (jobState == "Done") {
            _paymodel = Paymodel(name: name, service: service, phone: phone);
          }

          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Paymentscreen(),
                ),
              );
            },
            child: Card(
              child: Row(
                children: [
                  Text("${_paymodel?.name} + iii"),
                  Text("${_paymodel?.phone}"),
                  Text("${_paymodel?.service}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
