import 'package:clean_me_partner/constants.dart';
import 'package:clean_me_partner/providers/authentication_provider.dart';
import 'package:clean_me_partner/providers/complaint_provider.dart';
import 'package:clean_me_partner/providers/location_provider.dart';
import 'package:clean_me_partner/screens/splash_screen.dart';
import 'package:clean_me_partner/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ComplaintProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => CartProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => OrderProvider(),
        // ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initializeFlutterFire() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Grocery',
      theme: theme(),
      home: const SplashScreen(),
      routes: routes,
      builder: EasyLoading.init(),
    );
  }
}
