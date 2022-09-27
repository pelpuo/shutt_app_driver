import 'package:cloud_firestore/cloud_firestore.dart';

class Stop {
  String uid;
  String name;
  GeoPoint location;

  Stop({required this.uid, required this.name, required this.location});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'location': location,
    };
  }

  Stop.fromMap(Map<String, dynamic> stopMap)
      : uid = stopMap["uid"],
        name = stopMap["name"],
        location = stopMap["location"];

  Stop.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        name = doc.data()!["name"],
        location = doc.data()!["location"];
}
