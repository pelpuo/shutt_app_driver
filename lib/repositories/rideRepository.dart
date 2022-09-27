import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/Ride.dart';

class RideRepository {
  RideRepository._();
  static RideRepository? _instance;

  static RideRepository? get instance {
    if (_instance == null) {
      _instance = RideRepository._();
    }
    return _instance;
  }

  final _firestoreRideCollection =
      FirebaseFirestore.instance.collection('rides');

  ValueNotifier<List<Ride>> ridesNotifier = ValueNotifier<List<Ride>>([]);
  List<Ride> get rides => ridesNotifier.value;

  Future<Ride?> loadRide(String id) async {
    try {
      final ride = rides.firstWhere((Ride ride) => ride.uid == id);
      return ride;
    } catch (_) {
      try {
        final doc = await _firestoreRideCollection.doc(id).get();
        final ride = Ride.fromMap(doc.data() ?? {});
        ridesNotifier.value.add(ride);
        ridesNotifier.notifyListeners();

        return ride;
      } on FirebaseException catch (e) {
        print(e.message);
        return null;
      }
    }
  }

  Future<List<Ride>> loadAllUserRides(String ownerUID) async {
    try {
      final snapshot = _firestoreRideCollection
          .where('owner_uid', isEqualTo: ownerUID)
          .snapshots();
      snapshot.listen((query) {
        _addToRides(query);
      });
      return rides;
    } on FirebaseException catch (_) {
      print('something occurred');
      return rides;
    }
  }

  void _addToRides(QuerySnapshot<Map<String, dynamic>> query) {
    Future.wait(query.docs.map((doc) async {
      final ride = Ride.fromMap(doc.data());
      final index = rides.indexWhere((rideX) => rideX.uid == ride.uid);
      if (index != -1) {
        ridesNotifier.value.removeAt(index);
        ridesNotifier.value.insert(index, ride);
      } else {
        ridesNotifier.value.add(ride);
      }
      ridesNotifier.notifyListeners();
    }));
  }

  Future<Ride?> cancelRide(String id) async {
    try {
      await _firestoreRideCollection.doc(id).update({'status': 5});
      final ride = await loadRide(id);
      return ride;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  Future<Ride?> boardRide(Ride ride) async {
    try {
      await _firestoreRideCollection.doc(ride.uid).set({
        'startPointID': ride.startPointID,
        'stopPointID': ride.stopPointID,
        'userID': ride.userID,
        'busID': ride.busID,
        'fare': ride.fare,
      });
      final addedRide = await loadRide(ride.uid);
      return addedRide;
    } on FirebaseException catch (_) {
      print('could not board ride');
      return null;
    }
  }
}
