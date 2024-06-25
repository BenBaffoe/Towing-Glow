import 'package:onroadvehiclebreakdowwn/models/activeServiceProviders.dart';

class GeofireAssistant {
  static List<ActiveServiceProviders> activeServiceList = [];

  // static get activeServiceProviderList => null;

  static void deletedOfflineDriverFromList(String serviceId) {
    int indexNumber = activeServiceList
        .indexWhere((element) => element.serviceId == serviceId);

    activeServiceList.remove(indexNumber);
  }

  static void updateActiveDriverLocation(
      ActiveServiceProviders serviceProviderOnMove) {
    int indexNumber = activeServiceList.indexWhere(
        (element) => element.serviceId == serviceProviderOnMove.serviceId);

    activeServiceList[indexNumber].locationLatitude =
        serviceProviderOnMove.locationLatitude;

    activeServiceList[indexNumber].locationLongitude =
        serviceProviderOnMove.locationLongitude;
  }

  static void updateActiveLocation(
      ActiveServiceProviders activeServiceProviders) {}
}
