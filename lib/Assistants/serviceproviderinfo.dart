import 'package:google_maps_flutter/google_maps_flutter.dart';

class ServiceProviderInfo {
  LatLng? serivceProviderLocation;
  String? serivceProviderName;
  String? serivceProviderPhone;
  String? serivceProviderLocationAddress;
  String? time;

  ServiceProviderInfo({
    this.serivceProviderLocation,
    this.serivceProviderName,
    this.serivceProviderPhone,
    this.serivceProviderLocationAddress,
    this.time,
  });
}
