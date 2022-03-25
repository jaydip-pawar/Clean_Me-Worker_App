import 'package:clean_me_partner/models/dialog_box.dart';
import 'package:clean_me_partner/models/locationNavigator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AuthenticationProvider with ChangeNotifier {
  final firestoreInstance = FirebaseFirestore.instance;

  void login(String email, String password, BuildContext context) async {
    EasyLoading.show(status: "Please wait...");
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      EasyLoading.showSuccess("Login Successful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.dismiss();
        return showDialog(
          context: context,
          builder: (_) => const CustomAlertDialog(
            title: 'Sign in',
            description:
                'Sorry, we cant\'t find an account with this email address. Please try again or create a new account.',
            bText: 'Try again',
          ),
        );
      } else if (e.code == 'wrong-password') {
        EasyLoading.dismiss();
        return showDialog(
          context: context,
          builder: (_) => const CustomAlertDialog(
            title: 'Incorrect Password',
            description: 'Your username or password is incorrect.',
            bText: 'Try again',
          ),
        );
      }
    }
  }

  void signUp(String name, String email, String password, int mobileNumber,
      BuildContext context) async {
    EasyLoading.show(status: "Please wait...");
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      addUserData(name, email, mobileNumber, context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        EasyLoading.dismiss();
        return showDialog(
          context: context,
          builder: (_) => const CustomAlertDialog(
            title: 'Email address already in use',
            description: 'Please sign in.',
            bText: 'OK',
          ),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void addUserData(
      String name, String email, int mobileNumber, BuildContext context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("user_data").doc(firebaseUser!.uid).set({
      "name": name,
      "email": email,
      "mobile_number": mobileNumber,
      "uid": firebaseUser.uid,
    }).then((_) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const LocationNavigatePage()));
      EasyLoading.showSuccess("Signup Successful");
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
