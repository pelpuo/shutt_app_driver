import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shutt_app_driver/providers/mapProvider.dart';
import 'package:shutt_app_driver/services/authService.dart';
import 'package:shutt_app_driver/services/dbService.dart';

import '../models/Bus.dart';
import '../models/Driver.dart';
import '../models/Organization.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberPlateController = TextEditingController();
  String verificationId = "";
  bool signUpComplete = false;
  int _signUpState = 1;
  Driver? currentDriver;
  List<Organization> organizations = [];
  Organization? driverOrganization;
  dbService _dbService = dbService();
  User? curUser;
  bool orgsSet = false;
  bool signUpChecked = false;

  void setUser(user) {
    curUser = user;
    notifyListeners();
  }

  get user {
    return curUser;
  }

  get signUpState {
    return _signUpState;
  }

  set signUpState(state) {
    _signUpState = state;
    notifyListeners();
  }

  // Edit users info in signUp 3
  addJobDetails() async {
    List<Bus> buses = await _dbService
        .findBusByNumberPlate(numberPlateController.text.trim().toUpperCase());

    if (buses.isNotEmpty) {
      currentDriver = Driver(
          uid: curUser!.uid,
          companyID: driverOrganization!.uid,
          busID: buses[0].uid);

      _dbService.addDriverDetails(currentDriver!);
    }
  }

  editDetails() async {
    await AuthService().editCredentials(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim()); // notifyListeners();
  }

  getOrganizations() async {
    var temp = await _dbService.retrieveOrganizations();
    organizations = temp;
    orgsSet = true;

    notifyListeners();
  }

  checkSignUpComplete() async {
    print("asdsadasexecuting........................");
    var stream = AuthService().authStateChanges.listen((curUser) async {
      if (curUser?.uid != null && curUser?.uid != "") {
        print("Executing................");
        var driverExists = await _dbService.checkDriverExists(curUser!.uid);

        signUpComplete = driverExists.exists;

        if (driverExists.exists) {
          currentDriver = Driver.fromDocumentSnapshot(driverExists);
          // MapProvider().driverUser = Driver.fromDocumentSnapshot(driverExists);
        }

        print("DRIVER: $currentDriver");
        print("OTHER DRIVER: ${MapProvider().driverUser}");

        signUpChecked = true;

        notifyListeners();
        print("333");
        // return;
      }
    });
    // stream.cancel();
  }
}
