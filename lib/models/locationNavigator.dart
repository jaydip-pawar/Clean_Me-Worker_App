import 'package:clean_me_partner/models/location_permission.dart' as lc;
import 'package:clean_me_partner/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationNavigatePage extends StatefulWidget {
  const LocationNavigatePage({Key? key}) : super(key: key);

  @override
  State<LocationNavigatePage> createState() => _LocationNavigatePageState();
}

class _LocationNavigatePageState extends State<LocationNavigatePage> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Geolocator.getServiceStatusStream(),
      builder: (ctx, snapshot) {

        if (snapshot.data == ServiceStatus.enabled) {
          return const HomeScreen();
        }

        if(snapshot.data == ServiceStatus.disabled) {
          return const lc.LocationPermission();
        }

        return FutureBuilder(
          future: Location.instance.serviceEnabled(),
          builder: (ctx, snap) {
            if(snap.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if(snap.hasData) {
              if(snap.data == true) {
                return const HomeScreen();
              }
              return const lc.LocationPermission();
            }
            return Container();
          },
        );
      },
    );
  }
}
