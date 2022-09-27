import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/providers/authProvider.dart';
import 'package:shutt_app_driver/screens/home.dart';
import 'package:shutt_app_driver/screens/signUp3.dart';
import 'package:shutt_app_driver/screens/signUp4.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    checks();
  }

  checks() async {
    await Provider.of<AuthProvider>(context, listen: false)
        .checkSignUpComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, auth, child) => !auth.signUpChecked
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : auth.signUpComplete
                ? const Home()
                : auth.signUpState == 3
                    ? const SignUp3()
                    : auth.signUpState == 4
                        ? const SignUp4()
                        : const Scaffold(
                            body: Center(
                              child: Text("Something went wrong"),
                            ),
                          ));
  }
}
