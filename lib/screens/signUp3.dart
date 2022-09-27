import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/providers/authProvider.dart';
import 'package:shutt_app_driver/screens/authWrapper.dart';
import 'package:shutt_app_driver/services/dbService.dart';
import 'package:shutt_app_driver/widgets/customTextField.dart';
import 'package:shutt_app_driver/widgets/greenButton.dart';
import 'package:shutt_app_driver/widgets/headingText.dart';
import 'package:shutt_app_driver/styles/colors.dart';

import '../models/Organization.dart';
import '../services/authService.dart';

class SignUp3 extends StatefulWidget {
  const SignUp3({Key? key}) : super(key: key);

  @override
  State<SignUp3> createState() => _SignUp3State();
}

List<Organization> organizations = [];

class _SignUp3State extends State<SignUp3> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getOrganizations();
    super.didChangeDependencies();
  }

  getOrganizations() async {
    var temp = await Provider.of<dbService>(context).retrieveOrganizations();

    setState(() {
      organizations = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(
            Icons.arrow_back,
            color: appColors.green,
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) => Column(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeadingText(text: "Finish Registration"),
                  const SizedBox(height: 6),
                  const Text(
                    "Please fill in the following personal information",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: appColors.textGrey),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  CustomTextField(
                      onPressed: () {},
                      textController: auth.firstNameController,
                      hintText: "First Name"),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                      onPressed: () {},
                      textController: auth.lastNameController,
                      hintText: "Last Name"),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    onPressed: () {},
                    textController: auth.emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              )),
              greenButton(
                label: "Next",
                onPressed: () async {
                  await auth.editDetails();

                  await context.read<AuthService>().editCredentials(
                      firstName: auth.firstNameController.text.trim(),
                      lastName: auth.lastNameController.text.trim(),
                      email: auth.emailController.text.trim());
                  // auth.signUpComplete = true;
                  auth.signUpState = 4;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
