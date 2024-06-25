import 'package:flutter/material.dart';
import 'package:onroadvehiclebreakdowwn/Assistants/request_assistant.dart';
import 'package:onroadvehiclebreakdowwn/Info/app_info.dart';
import 'package:onroadvehiclebreakdowwn/global/global.dart';
import 'package:onroadvehiclebreakdowwn/models/directions.dart';
import 'package:onroadvehiclebreakdowwn/models/predicated_place.dart';
import 'package:onroadvehiclebreakdowwn/widgets/progress.dialog.dart';
import 'package:provider/provider.dart';

class PlacePredictionTile extends StatefulWidget {
  final PredictPlaces? predictedPlaces;

  const PlacePredictionTile({super.key, this.predictedPlaces});

  @override
  State<PlacePredictionTile> createState() => _PlacePredictionTileState();
}

class _PlacePredictionTileState extends State<PlacePredictionTile> {
  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Finding a service , Please wait...",
            ));
    String placeDirectionUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId$Key=$googlesMapKey";

    var responseApi = await RequestAssistant.recieveRequest(placeDirectionUrl);

    Navigator.pop(context);

    if (responseApi == "Error Occured ") {
      return;
    }

    if (responseApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseApi['result']['name'];
      directions.loactionId = placeId as double?;
      directions.loactionLatitude =
          responseApi['result']['geometry']['location']['lat'];
      directions.loactionLongitude =
          responseApi['result']['geometry']['location']['lng'];

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getPlaceDirectionDetails(widget.predictedPlaces!.placeId, context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.add_location,
            color: Colors.red,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.predictedPlaces!.mainText!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                widget.predictedPlaces!.mainText!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
