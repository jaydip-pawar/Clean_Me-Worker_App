import 'package:clean_me_partner/constants.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationPermission extends StatelessWidget {
  static const String id = 'location-permission-screen';

  const LocationPermission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Image.asset("assets/gifs/location.gif"),
          ),
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 40),
                  child: Text(
                    "Need Your Location",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF667CE8)),
                  ),
                ),
                SizedBox(
                  width: width(context) * 0.6,
                  child: const Text(
                    "Please give us access to your GPS Location",
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: SizedBox(
              width: width(context) * 0.8,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    primary: Colors.red),
                child: const Text(
                  "Turn on Location Services",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  ),
                ),
                onPressed: () {
                  Location location = Location();
                  location.requestService();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
