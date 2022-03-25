import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {

  bool serviceEnabled = false;
  double latitude = 0.0;
  double longitude = 0.0;
  PermissionStatus permissionGranted = PermissionStatus.denied;
  LocationData? userLocation;
  Address address = Address();
  GeoCode geoCode = GeoCode();
  late StreamSubscription<LocationData> stream;
  Location location = Location();
  bool ready = true;

  Future<String> getUserCurrentLocation() async {
    // Check if location service is enable
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return "Service-Disabled";
      }
    }

    // Check if permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return "Permission-Denied";
      }
    }

    await location.getLocation().then((currentLocation) {
      userLocation = currentLocation;
      latitude = currentLocation.latitude ?? 0;
      longitude = currentLocation.longitude ?? 0;
    });

    await getAddress(userLocation!.latitude, userLocation!.longitude);

    stream = location.onLocationChanged.listen((LocationData currentLocation) async {
      latitude = currentLocation.latitude!;
      longitude = currentLocation.longitude!;
      userLocation = currentLocation;
      await getAddress(userLocation!.latitude, userLocation!.longitude);
      notifyListeners();
    });
    return "Success";
  }

  Future<GeoPoint> getGeoPoint() async {
    GeoPoint geoPoint = const GeoPoint(0, 0);
    await location.getLocation().then((location) {
      geoPoint = GeoPoint(getLatitude(location.latitude), getLongitude(location.longitude));
    });
    return geoPoint;
  }

  double getLatitude(latitude) {
    return latitude;
  }

  double getLongitude(longitude) {
    return longitude;
  }

  String getSAddress(address) {
    return address;
  }

  Future<void> getAddress(latitude, longitude) async {
    try {
      if(ready) {
        ready = false;
        await geoCode.reverseGeocoding(latitude: latitude, longitude: longitude).then((value) {
          address = value;
          ready = true;
        });
      }
    } catch (e) {
      await getAddress(userLocation!.latitude, userLocation!.longitude);
    }
  }

  double getDistance(GeoPoint location) {
    var distance = Geolocator.distanceBetween(
      userLocation!.latitude ?? 00,
      userLocation!.longitude ?? 00,
      location.latitude,
      location.longitude,
    );
    var distanceInKm = distance / 1000;
    return double.parse(distanceInKm.toStringAsFixed(2));
  }

}