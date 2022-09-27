import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  String uid;
  String startPointID;
  String stopPointID;
  String userID;
  String busID;
  double fare;
  String status;
  double rating;

  Ride(
      {required this.uid,
      required this.startPointID,
      required this.stopPointID,
      required this.userID,
      required this.busID,
      required this.status,
      required this.fare,
      required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'startPointID': startPointID,
      'stopPointID': stopPointID,
      'userID': userID,
      'busID': busID,
      'fare': fare,
      'status': status,
      'rating': rating
    };
  }

  Ride.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        startPointID = map["startPointID"],
        stopPointID = map["stopPointID"],
        userID = map["userID"],
        busID = map["busID"],
        rating = map["rating"],
        status = map["status"],
        fare = map["fare"];

  Ride.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        startPointID = doc.data()!["startPointID"],
        stopPointID = doc.data()!["stopPointID"],
        userID = doc.data()!["userID"],
        busID = doc.data()!["busID"],
        status = doc.data()!["status"],
        rating = doc.data()!["rating"],
        fare = doc.data()!["fare"];
}
