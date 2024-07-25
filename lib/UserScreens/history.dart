import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onroadvehiclebreakdowwn/models/retrievedata.dart';

class History extends StatefulWidget {
  Retrievedata? userHistory;
  History({super.key, required this.userHistory});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 200,
                child: Text(
                  widget.userHistory!.userName!,
                  style: const TextStyle(shadows: [
                    Shadow(
                        blurRadius: 15,
                        color: Colors.grey,
                        offset: Offset(0.4, 4))
                  ]),
                ),
              ),
              Column(
                children: [
                  Text(
                    "Service Request " + widget.userHistory!.service!,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.w200),
                  ),
                  Text(
                    "User Location at the time " +
                        widget.userHistory!.userlocation!,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.w200),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Service Provider " +
                        widget.userHistory!.serviceProviderName!,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.w200),
                  ),
                  Text(
                    "Service Proivder Location At The time " +
                        widget.userHistory!.serviceProviderLocation!,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
