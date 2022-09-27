import 'package:cloud_firestore/cloud_firestore.dart';

class Route {
  String uid;
  String name;
  List stopIDs;

  Route({required this.uid, required this.name, required this.stopIDs});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'stopIDs': stopIDs,
    };
  }

  Route.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        name = map["name"],
        stopIDs = map["stopIDs"];

  Route.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        name = doc.data()!["name"],
        stopIDs = doc.data()!["stopIDs"];
}
