import 'package:clean_me_partner/constants.dart';
import 'package:clean_me_partner/models/google_map.dart';
import 'package:clean_me_partner/providers/location_provider.dart';
import 'package:clean_me_partner/screens/home/widgets/complaint_list.dart';
import 'package:clean_me_partner/screens/home/widgets/my_appbar.dart';
import 'package:clean_me_partner/services/complaint_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MyAppBar(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: height(context) * 0.37,
            child: const MyGoogleMap(),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              maxChildSize: 0.9,
              minChildSize: 0.415,
              initialChildSize: 0.43,
              builder: (ctx, controller) {
                return Material(
                  elevation: 10,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  color: Colors.white,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: ComplaintService().complaints,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        Map nearbyComplaints = snapshot.data!.docs.asMap();
                        return ListView.builder(
                          controller: controller,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            if(index == 0) {
                              if (locationProvider.getDistance(nearbyComplaints[index]["location"]) <= 2) {
                                return ComplaintList(
                                  image: nearbyComplaints[index]["image"],
                                  address: nearbyComplaints[index]["address"],
                                  startLatitude: locationProvider.latitude,
                                  startLongitude: locationProvider.longitude,
                                  endLatitude: nearbyComplaints[index]["location"].latitude,
                                  endLongitude: nearbyComplaints[index]["location"].longitude,
                                  isFirst: true,
                                );
                              }
                            } else {
                              if (locationProvider.getDistance(nearbyComplaints[index]["location"]) <= 2) {
                                return ComplaintList(
                                  image: nearbyComplaints[index]["image"],
                                  address: nearbyComplaints[index]["address"],
                                  startLatitude: locationProvider.latitude,
                                  startLongitude: locationProvider.longitude,
                                  endLatitude: nearbyComplaints[index]["location"].latitude,
                                  endLongitude: nearbyComplaints[index]["location"].longitude,
                                  isFirst: false,
                                );
                              }
                            }
                            return Container();
                          },
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
