import 'package:clean_me_partner/providers/location_provider.dart';
import 'package:clean_me_partner/services/map_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({Key? key}) : super(key: key);

  @override
  State<MyGoogleMap> createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {

  late GoogleMapController googleMapController;
  late BitmapDescriptor dustbinIcon;

  static const CameraPosition initialCameraPosition =
  CameraPosition(target: LatLng(19.0760, 72.8777), zoom: 14);

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(2, 3)),
        'assets/images/dustbin.png')
        .then((d) {
      dustbinIcon = d;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locationProvider = Provider.of<LocationProvider>(context);
    markers.remove("currentLocation");
    markers.add(
      Marker(
        markerId: const MarkerId("currentLocation"),
        position: LatLng(
          locationProvider.latitude,
          locationProvider.longitude,
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final locationProvider = Provider.of<LocationProvider>(context);

    void currentLocationMarker() {
      markers.remove("currentLocation");
      markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: LatLng(
            locationProvider.latitude,
            locationProvider.longitude,
          ),
        ),
      );
      setState(() {});
    }

    return StreamBuilder<QuerySnapshot>(
      stream: MapServices().dustbins,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          Map data = snapshot.data!.docs.asMap();
          for(int i = 0; i < snapshot.data!.docs.length; i++) {
            markers.add(
              Marker(
                markerId: MarkerId("${data[i]['location'].latitude}, ${data[i]['location'].longitude}"),
                position: LatLng(
                  data[i]['location'].latitude,
                  data[i]['location'].longitude,
                ),
                icon: dustbinIcon,
              ),
            );
          }
        }

        return SizedBox(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: locationProvider.latitude == 0.0
                    ? initialCameraPosition
                    : CameraPosition(target: LatLng(locationProvider.latitude, locationProvider.longitude), zoom: 14),
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                },
              ),
              Align(
                alignment: const Alignment(0.9, 0.8),
                child: IconButton(
                  icon: const Icon(
                    Icons.my_location_sharp,
                    size: 40,
                  ),
                  onPressed: () {
                    googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            locationProvider.latitude,
                            locationProvider.longitude,
                          ),
                          zoom: 14,
                        ),
                      ),
                    );
                    currentLocationMarker();
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
