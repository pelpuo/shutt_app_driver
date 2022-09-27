import 'package:cloud_firestore/cloud_firestore.dart';

class Bus {
  String uid;
  String registrationNumber;
  bool isActive;
  String routeID;
  GeoPoint location;
  int capacity;
  double speed;

  Bus(
      {required this.uid,
      required this.isActive,
      required this.routeID,
      required this.registrationNumber,
      required this.location,
      required this.speed,
      required this.capacity});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'isActive': isActive,
      'registrationNumber': registrationNumber,
      'routeID': routeID,
      'location': location,
      'capacity': capacity,
      'speed': speed,
    };
  }

  Bus.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        registrationNumber = map["registrationNumber"],
        routeID = map["routeID"],
        isActive = map["isActive"],
        location = map["location"],
        speed = map["speed"],
        capacity = map["capacity"];

  Bus.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        isActive = doc.data()!["isActive"],
        registrationNumber = doc.data()!["registrationNumber"],
        routeID = doc.data()!["routeID"],
        location = doc.data()!["location"],
        speed = doc.data()!["speed"],
        capacity = doc.data()!["capacity"];
}
