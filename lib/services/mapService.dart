import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shutt_app_driver/models/User.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/providers/authProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class mapService {
  final Stream<QuerySnapshot> stops =
      FirebaseFirestore.instance.collection("stops").snapshots();
}
