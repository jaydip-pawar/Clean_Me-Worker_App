import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintService {

  Stream<QuerySnapshot> complaints = FirebaseFirestore.instance.collection("complaints").snapshots();

}