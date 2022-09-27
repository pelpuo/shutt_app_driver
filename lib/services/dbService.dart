import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:shutt_app_driver/models/Bus.dart';
import 'package:shutt_app_driver/models/Organization.dart';
import 'package:shutt_app_driver/models/Stop.dart';
import 'package:shutt_app_driver/providers/authProvider.dart';

import '../models/Driver.dart';
import '../models/Ride.dart';
import '../models/Route.dart';

class dbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Stops //////////////////////////////////////////////////////////
  // addStop(Stop stop) async {
  //   await _firestore.collection("stops").add(stop.toMap());
  // }

  updateStop(Stop stop) async {
    await _firestore.collection("stops").doc(stop.uid).update(stop.toMap());
  }

  Future<void> deleteStop(String documentId) async {
    await _firestore.collection("stops").doc(documentId).delete();
  }

  Future<List<Stop>> retrieveStops() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("stops").get();

    List<Stop> stops = snapshot.docs
        .map((docSnapshot) => Stop.fromDocumentSnapshot(docSnapshot))
        .toList();
    return stops;
  }

// Bus //////////////////////////////////////////////////////////
  Future<List<Bus>> retrieveBuses() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("buses").get();

    List<Bus> buses = snapshot.docs
        .map((docSnapshot) => Bus.fromDocumentSnapshot(docSnapshot))
        .toList();
    return buses;
  }

  findBusById(String busId) async {
    print("///////////////////////////////////////////////////////////////");
    print(busId);
    DocumentSnapshot<Map<String, dynamic>> busSnapshot =
        await _firestore.collection("buses").doc(busId).get();
    print(busSnapshot);
    Bus bus = Bus.fromDocumentSnapshot(busSnapshot);

    return bus;
  }

  findBusByNumberPlate(String plate) async {
    QuerySnapshot<Map<String, dynamic>> busSnapshot = await _firestore
        .collection("buses")
        .where("registrationNumber", isEqualTo: plate)
        .get();
    List<Bus> buses = busSnapshot.docs
        .map((docSnapshot) => Bus.fromDocumentSnapshot(docSnapshot))
        .toList();
    return buses;
  }

  findBusOnRoute(Stop pickUpPoint, Stop dropOffPoint) async {
    // Add new parameter for user location
    QuerySnapshot<Map<String, dynamic>> routeSnapshot = await _firestore
        .collection("routes")
        .where("stopIDs", arrayContains: pickUpPoint.uid)
        .get();

    List<Route> routes = routeSnapshot.docs
        .map((docSnapshot) => Route.fromDocumentSnapshot(docSnapshot))
        .toList();
    // print("Routes: $routes");

    List<Bus> busesOnRoute = [];

    for (var route in routes) {
      QuerySnapshot<Map<String, dynamic>> busSnapshot = await _firestore
          .collection("buses")
          .where("routeID", isEqualTo: route.uid)
          .where("isActive", isEqualTo: true)
          .get();
      // print("Bus snapshot: ${busSnapshot.docs.length}");

      List<Bus> busesOnCurrentRoute = busSnapshot.docs
          .map((docSnapshot) => Bus.fromDocumentSnapshot(docSnapshot))
          .toList();
      busesOnRoute = busesOnRoute + busesOnCurrentRoute;
      print("Buses on Route: $busesOnRoute");

      if (routes.indexOf(route) == routes.length - 1) {
        return busesOnRoute[0];
      }
    }

    // Add change to get active bus with shortest distance to user
    if (busesOnRoute.isNotEmpty) {
      return busesOnRoute[0];
    }
  }

  Stream<QuerySnapshot> tripStream() {
    CollectionReference reference = _firestore.collection("trips");
    return reference.snapshots();
  }

// Driver Details //////////////////////////////////////////////////////////
  Stream<DocumentSnapshot> userDetailsStream(String driverId) {
    DocumentReference reference =
        _firestore.collection("drivers").doc(driverId);
    return reference.snapshots();
  }

  addDriverDetails(Driver driver) async {
    await _firestore.collection("drivers").doc(driver.uid).set(driver.toMap());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> checkDriverExists(
      String userID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("drivers").doc(userID).get();

    return snapshot;
  }

  Future<Driver> retrieveDriverDetails(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("drivers").doc(userID).get();

    Driver driverDetails = Driver.fromDocumentSnapshot(snapshot);

    return driverDetails;
  }

  addRide(Ride ride) async {
    await _firestore.collection("rides").doc(ride.uid).set(ride.toMap());
  }

  updateRide(Ride ride) async {
    await _firestore.collection("stops").doc(ride.uid).update(ride.toMap());
  }

  updateIsActive(String busId, Bus bus) async {
    await _firestore.collection("buses").doc(busId).set(bus.toMap());
  }

// Organizations ///////////////////////////////////////////////////////////
  Future<List<Organization>> retrieveOrganizations() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("organizations").get();

    List<Organization> organizations = snapshot.docs
        .map((docSnapshot) => Organization.fromDocumentSnapshot(docSnapshot))
        .toList();
    return organizations;
  }

  updateBusLocation(String busID, LocationData userLocation) async {
    await _firestore.collection("buses").doc(busID).update({
      "location": GeoPoint(userLocation.latitude ?? 5.804876,
          userLocation.longitude ?? -0.114641),
      "speed": userLocation.speed
    });
  }
}
