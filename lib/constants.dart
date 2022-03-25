import 'package:clean_me_partner/models/location_permission.dart';
import 'package:clean_me_partner/models/navigate_page.dart';
import 'package:clean_me_partner/screens/login/login_screen.dart';
import 'package:clean_me_partner/screens/splash_screen.dart';
import 'package:flutter/material.dart';

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

const kStoreCardStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey
);

Map<String, Widget Function(BuildContext)> routes = {
  SplashScreen.id : (context) => const SplashScreen(),
  NavigatePage.id : (context) => const NavigatePage(),
  LocationPermission.id : (context) => const LocationPermission(),
  LoginScreen.id : (context) => const LoginScreen(),
};