import 'package:flutter/material.dart';

class Requestscreen extends StatefulWidget {
  final String payload;
  const Requestscreen({super.key, required this.payload});

  @override
  State<Requestscreen> createState() => _RequestscreenState();
}

class _RequestscreenState extends State<Requestscreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 200,
        width: 300,
        child: Column(
          children: [Text(widget.payload)],
        ));
  }

  // Future _dispalyNotificationBottomSheet(BuildContext context, String payload) {
  //   return showModalBottomSheet(
  //     barrierColor: Colors.black.withOpacity(0.4),
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(30),
  //       ),
  //     ),
  //     builder: (context) => Container(
  //         color: Colors.white,
  //         height: 400,
  //         child: Column(
  //           children: [Text("$payload")],
  //         )),
  //   );
  // }
}
