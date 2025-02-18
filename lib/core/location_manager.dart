import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class LocationManager {
  Location location = Location();

  bool serviceEnabled = false;
  PermissionStatus permissionGranted = PermissionStatus.denied;
  LocationData? locationData;
  Future<bool> isLocationServiceEnabled() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }

  Future<bool> isLocationPermissionGranted() async {
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted;
  }

  Future<bool> canGetLocation() async {
    bool isPermissionGranted = await isLocationPermissionGranted();
    bool isServiceEnabled = await isLocationServiceEnabled();
    return isPermissionGranted && isServiceEnabled;
  }

  Future<LocationData> getUserLocation() async {
    locationData = await location.getLocation();
    if (kDebugMode) {
      print(locationData);
    }
    return location.getLocation();
  }

  Stream<LocationData> trackLocation() {
    return location.onLocationChanged;
  }
}
