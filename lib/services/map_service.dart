import 'package:cloud_firestore/cloud_firestore.dart';

class MapServices {

  Stream<QuerySnapshot> dustbins = FirebaseFirestore.instance.collection("dustbins").snapshots();

}