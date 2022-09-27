import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  String uid;
  String companyID;
  String busID;
  bool isVerified;

  Driver(
      {required this.uid,
      required this.companyID,
      this.isVerified = false,
      required this.busID});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'companyID': companyID,
      'busID': busID,
      'isVerified': isVerified,
    };
  }

  Driver.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        companyID = map["companyID"],
        isVerified = map["isVerified"],
        busID = map["busID"];

  Driver.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        companyID = doc.data()!["companyID"],
        isVerified = doc.data()!["isVerified"],
        busID = doc.data()!["busID"];
}
