// import 'package:flutter/material.dart';
// import 'package:onroadvehiclebreakdowwn/global/global.dart';
// import 'package:onroadvehiclebreakdowwn/models/predicated_place.dart';
// import 'package:onroadvehiclebreakdowwn/widgets/place_prediction_tile.dart';
// import 'package:onroadvehiclebreakdowwn/Assistants/request_assistant.dart';

// class UserSearch extends StatefulWidget {
//   const UserSearch({super.key});

//   @override
//   State<UserSearch> createState() => _UserSearchState();
// }

// class _UserSearchState extends State<UserSearch> {
//   List<PredictPlaces> placePredictedList = [];

//   Future<void> findPlaceAutoComplete(String inputText) async {
//     if (inputText.length > 1) {
//       String urlAutoComplete =
//           "https://maps.googleapis.com/maps/apis/place/autocomplete/json?input=$inputText&Key=$googlesMapKey&components=country:GH ";

//       var responseAutoComplete =
//           await RequestAssistant.recieveRequest(urlAutoComplete);

//       if (responseAutoComplete == "Error Occured") {
//         return;
//       }

//       if (responseAutoComplete["status"] == "OK") {
//         var placePredictions = responseAutoComplete["predictions"];

//         var placePredictionsList = (placePredictions as List)
//             .map((jsonData) => PredictPlaces.fromJson(jsonData))
//             .toList();

//         setState(() {
//           placePredictedList = placePredictionsList;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool darkTheme =
//         MediaQuery.of(context).platformBrightness == Brightness.dark;
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         backgroundColor: darkTheme ? Colors.black : Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           ),
//           title: const Padding(
//             padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
//             child: Text(
//               "Search & Set Towing Point",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           elevation: 0,
//         ),
//         body: Column(
//           children: [
//             Container(
//               decoration: const BoxDecoration(color: Colors.black, boxShadow: [
//                 BoxShadow(
//                   color: Colors.white54,
//                   blurRadius: 0,
//                   spreadRadius: 0.5,
//                   offset: Offset(0.7, 0.7),
//                 )
//               ]),
//               child: Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Column(children: [
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.adjust_sharp,
//                         color: Colors.green,
//                       ),
//                       const SizedBox(
//                         height: 18,
//                       ),
//                       Expanded(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8),
//                         child: TextField(
//                           onChanged: (value) {
//                             findPlaceAutoComplete(value);
//                           },
//                           decoration: const InputDecoration(
//                               hintText: "Search towing point ",
//                               fillColor: Colors.white,
//                               filled: true,
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.only(
//                                 left: 11,
//                                 top: 8,
//                                 bottom: 8,
//                               )),
//                         ),
//                       )),
//                     ],
//                   )
//                 ]),
//               ),
//             ),
//             //display predictions
//             (placePredictedList.length > 0)
//                 ? Expanded(
//                     child: ListView.separated(
//                       itemCount: placePredictedList.length,
//                       itemBuilder: (context, index) {
//                         return PlacePredictionTile(
//                           predictedPlaces: placePredictedList[index],
//                         );
//                       },
//                       physics: const ClampingScrollPhysics(),
//                       separatorBuilder: (BuildContext context, int index) {
//                         return const Divider(
//                           height: 0,
//                           color: Colors.blue,
//                           thickness: 0,
//                         );
//                       },
//                     ),
//                   )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }
