import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;
import 'dart:async';

import 'package:location/location.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shutt_app_driver/models/Organization.dart';
import 'package:shutt_app_driver/models/Stop.dart';
import 'package:shutt_app_driver/providers/authProvider.dart';
import 'package:shutt_app_driver/services/authService.dart';
import 'package:shutt_app_driver/services/dbService.dart';

import '../models/Bus.dart';
import '../models/Driver.dart';
import '../models/Ride.dart';

class MapProvider with ChangeNotifier {
  initialize() async {
    // await getCurrentLocation();
    // await addRandomMarkers();
    await createPolylines(
        LatLng(5.653794, -0.189129), LatLng(5.804876, -0.114641), Colors.black);
  }

  String locationTextState = "";

  TextEditingController pickUpPointController = TextEditingController();
  TextEditingController dropOffPointController = TextEditingController();

  Location location = Location();
  LocationData? userLocation;
  LocationData? lastUserLocation;

  Stop? pickupPoint;
  Stop? dropOffPoint;
  Bus? busOnRoute;
  Ride? ride;
  Marker? busMarker;
  bool tripStarted = false;
  BitmapDescriptor? locationIcon;
  //  this variable will listen to the status of the ride request
  StreamSubscription<QuerySnapshot>? rideRequestStream;
  // this variable will keep track of the drivers position before and during the ride
  StreamSubscription<QuerySnapshot>? busStream;
//  this stream is for all the driver on the app
  StreamSubscription<List<Bus>>? allBusesStream;

  dbService _dbService = dbService();
  AuthProvider _authProvider = AuthProvider();

  int orderState = 1;

  void setOrderState(int val) {
    orderState = val;
    notifyListeners();
  }

  Set<Marker> markers = {};
  // Map<PolylineId, Polyline> polylines = {};
  final Set<Polyline> polylines = {};
  final Geolocator geolocator = Geolocator();
  Position? currentPosition;
  GoogleMapController? mapController;
  PolylinePoints? polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Completer<GoogleMapController> controller = Completer();
  String? userID;
  // BitmapDescriptor busIcon;
  LatLng? _center;
  LatLng get center => _center ?? const LatLng(0, 0);
  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(5.6506, -0.1962), zoom: 15.5);

  String? placeDistance;
  Driver? driverUser;
  Bus? driverBus;

  onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    trackUserLocation();
    setDriverDetails();
    locationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/location_marker.png",
    );
    await animateCamera();

    notifyListeners();
  }

  setDriverDetails() async {
    // print("Driver user is $driverUser");
    try {
      var driverExists = await _dbService
          .checkDriverExists(FirebaseAuth.instance.currentUser!.uid);
      driverUser = Driver.fromDocumentSnapshot(driverExists);
      print("****************************************************************");
      print(driverUser!.busID);

      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  trackUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    try {
      lastUserLocation = await location.getLocation();
      location.enableBackgroundMode(enable: true);
      location.onLocationChanged.listen((LocationData currentLocation) {
        userLocation = currentLocation;
        print(
            "User Location: {${userLocation!.latitude}, ${userLocation!.longitude})");
        notifyListeners();

        if (tripStarted) {
          if (currentLocation.latitude != lastUserLocation!.latitude ||
              currentLocation.longitude != lastUserLocation!.longitude) {
            _dbService.updateBusLocation(driverUser!.busID, userLocation!);
            lastUserLocation = currentLocation;
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  animateCamera() async {
    var pos = await location.getLocation();
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pos.latitude!, pos.longitude!), zoom: 17)));
    notifyListeners();
  }

  moveCamera(LatLng newPosition) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: newPosition,
          zoom: 18.0,
        ),
      ),
    );
  }

  addMarker(LatLng location, title, {icon = BitmapDescriptor.defaultMarker}) {
    Marker newMarker = Marker(
      markerId: MarkerId('${location.latitude}-${location.longitude}'),
      position: location,
      infoWindow: InfoWindow(
        title: title,
      ),
      icon: icon,
    );

    markers.add(newMarker);

    notifyListeners();
  }

  addBusToMap(Bus bus) {
    LatLng latLng = new LatLng(bus.location.latitude, bus.location.longitude);

    Marker newMarker = Marker(
      markerId: MarkerId('${latLng.latitude}-${latLng.longitude}'),
      position: latLng,
      infoWindow: InfoWindow(
        title: bus.registrationNumber,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    markers.add(newMarker);
    busMarker = newMarker;
    notifyListeners();
  }

  addBusesToMap(List<Bus> buses) {
    // markers = {};
    for (Bus bus in buses) {
      LatLng latLng = new LatLng(bus.location.latitude, bus.location.longitude);

      Marker newMarker = Marker(
        markerId: MarkerId('${latLng.latitude}-${latLng.longitude}'),
        position: latLng,
        infoWindow: InfoWindow(
          title: bus.registrationNumber,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      markers.add(newMarker);
    }

    notifyListeners();
  }

  Future<void> createPolylines(LatLng start, LatLng destination, color) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult? result = await polylinePoints?.getRouteBetweenCoordinates(
      'AIzaSyA1fhjNGWYmYfsdccOjT8tQkdYZHTh6ve0', // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result?.points.isNotEmpty ?? false) {
      result?.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: color,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    // polylines[id] = polyline;
    polylines.add(polyline);
    notifyListeners();
  }

  onCreate(GoogleMapController controller) {
    mapController = controller;
    notifyListeners();
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  calculateDistance() {
    double totalDistance = 0.0;

// Calculating the total distance by adding the distance
// between small segments
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    placeDistance = totalDistance.toStringAsFixed(2);
    print('DISTANCE: $placeDistance km');
  }

  Future<void> gotoLocation(double lat, double long) async {
    final GoogleMapController _controller = await controller.future;
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
    notifyListeners();
  }

  setCustomMapPin(String image) async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), image);
    return icon;
  }

  getStops() {
    final Stream<QuerySnapshot> stops =
        FirebaseFirestore.instance.collection("stops").snapshots();
    // print(stops);
    // return stops;
  }

// Change to Listen for users
  listenForTrips() {
    busStream = _dbService.tripStream().listen((event) {
      event.docChanges.forEach((change) async {
        // print(change.doc.data());
        if (change.doc.id == busOnRoute?.uid) {
          var tempBus = (change.doc.data() as Map<String, dynamic>);
          tempBus["uid"] = change.doc.id;

          print(tempBus);

          busOnRoute = Bus.fromDocumentSnapshot(
              (change.doc as DocumentSnapshot<Map<String, dynamic>>));
          // code to update marker

          // updateBusMarker();
          markers.remove(busMarker);
          addBusToMap(busOnRoute!);
          print(markers.length);
        }
      });
    });

    notifyListeners();
  }

  addStopMarkers() async {
    List<Stop> stops = await _dbService.retrieveStops();

    for (var stop in stops) {
      LatLng stopLocation =
          LatLng(stop.location.latitude, stop.location.longitude);
      addMarker(stopLocation, stop.name, icon: locationIcon!);
    }
  }

  startTrip() async {
    var busExists = await _dbService.findBusById(driverUser!.busID);
    print("///////////////////////////////////////////////////////////////");
    print(busExists);
    driverBus = busExists;
    await addStopMarkers();
    driverBus!.isActive = true;
    await _dbService.updateIsActive(driverUser?.busID ?? "", driverBus!);
    tripStarted = true;
    notifyListeners();
  }

  stopTrip() async {
    markers = {};
    driverBus!.isActive = false;
    await _dbService.updateIsActive(driverUser?.busID ?? "", driverBus!);
    tripStarted = false;
    notifyListeners();
  }
}
