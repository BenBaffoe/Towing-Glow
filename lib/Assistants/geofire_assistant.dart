import 'package:onroadvehiclebreakdowwn/models/activeServiceProviders.dart';

class GeofireAssistant {
  static List<ActiveServiceProviders> activeServiceList = [];

  // static get activeServiceProviderList => null;

  static void deletedOfflineDriverFromList(String id) {
    int indexNumber =
        activeServiceList.indexWhere((element) => element.id == id);

    activeServiceList.remove(indexNumber);
  }

  static void updateActiveDriverLocation(
      ActiveServiceProviders serviceProviderOnMove) {
    int indexNumber = activeServiceList
        .indexWhere((element) => element.id == serviceProviderOnMove.id);

    activeServiceList[indexNumber].locationLatitude =
        serviceProviderOnMove.locationLatitude;

    activeServiceList[indexNumber].locationLongitude =
        serviceProviderOnMove.locationLongitude;
  }

  static void updateActiveLocation(
      ActiveServiceProviders activeServiceProviders) {}
}
