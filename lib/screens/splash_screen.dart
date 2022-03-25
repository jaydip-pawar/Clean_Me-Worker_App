import 'package:clean_me_partner/constants.dart';
import 'package:clean_me_partner/models/navigate_page.dart';
import 'package:clean_me_partner/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_image.jpg',
              width: width(context) * .5,
            ),
            const Center(
              child: Text(
                "KudaCam",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            FutureBuilder(
              future: locationProvider.getUserCurrentLocation(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.pushReplacementNamed(context, NavigatePage.id);
                  });

                }
                return const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
