import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/providers/mapProvider.dart';
import 'package:shutt_app_driver/screens/homeWrapper.dart';
import 'package:shutt_app_driver/screens/signUp1.dart';
import 'package:shutt_app_driver/screens/home.dart';
import 'package:shutt_app_driver/screens/signUp3.dart';
import 'package:shutt_app_driver/screens/signUpWrapper.dart';
import 'package:shutt_app_driver/services/authService.dart';

import '../providers/authProvider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      Provider.of<MapProvider>(context, listen: false).userID =
          firebaseUser.uid;
      return const HomeWrapper();
    } else {
      return const signUpWrapper();
    }
  }
}

// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({Key? key}) : super(key: key);

// //   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }

// class _AuthWrapperState extends State<AuthWrapper> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     Provider.of<AuthProvider>(context, listen: false).checkSignUpComplete();
//     print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
//     print(Provider.of<AuthProvider>(context).signUpComplete);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var firebaseUser = context.watch<User?>();
//     bool signupComplete = Provider.of<AuthProvider>(context).signUpComplete;

//     if (firebaseUser?.displayName != null && firebaseUser?.displayName != "") {
//       Provider.of<MapProvider>(context, listen: false).userID =
//           firebaseUser?.uid;
//       return const Home();
//     } else {
//       return const signUpWrapper();
//     }
//   }
// }
