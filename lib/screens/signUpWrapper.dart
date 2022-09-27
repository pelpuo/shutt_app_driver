import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/providers/authProvider.dart';
import 'package:shutt_app_driver/screens/signUp1.dart';
import 'package:shutt_app_driver/screens/signUp2.dart';
import 'package:shutt_app_driver/screens/signUp3.dart';
import 'package:shutt_app_driver/screens/signUp4.dart';

class signUpWrapper extends StatelessWidget {
  const signUpWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int signUpState = Provider.of<AuthProvider>(context).signUpState;

    if (signUpState == 1) {
      return const SignUp1();
    } else if (signUpState == 2) {
      return const SignUp2();
    }
    // else if (signUpState == 3) {
    //   return const SignUp3();
    // } else if (signUpState == 4) {
    //   return const SignUp4();
    // }
    else {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
