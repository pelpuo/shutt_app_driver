import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  String uid;
  String name;

  Organization({required this.uid, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
    };
  }

  Organization.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        name = map["name"];

  Organization.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        name = doc.data()!["name"];
}
