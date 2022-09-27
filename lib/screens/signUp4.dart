import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/providers/authProvider.dart';
import 'package:shutt_app_driver/providers/mapProvider.dart';
import 'package:shutt_app_driver/screens/authWrapper.dart';
import 'package:shutt_app_driver/services/dbService.dart';
import 'package:shutt_app_driver/widgets/customTextField.dart';
import 'package:shutt_app_driver/widgets/greenButton.dart';
import 'package:shutt_app_driver/widgets/headingText.dart';
import 'package:shutt_app_driver/styles/colors.dart';

import '../models/Organization.dart';
import '../services/authService.dart';

class SignUp4 extends StatefulWidget {
  const SignUp4({Key? key}) : super(key: key);

  @override
  State<SignUp4> createState() => _SignUp4State();
}

class _SignUp4State extends State<SignUp4> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Provider.of<AuthProvider>(context).getOrganizations();
    super.didChangeDependencies();
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
          builder: (context, auth, child) => !auth.orgsSet
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeadingText(text: "Finish Registration"),
                        const SizedBox(height: 6),
                        const Text(
                          "Please enter the following details about your vehicle",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: appColors.textGrey),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        // Dropdown starts
                        const Text("Organization:"),
                        const SizedBox(
                          height: 8,
                        ),
                        DecoratedBox(
                          decoration:
                              const BoxDecoration(color: appColors.offWhite),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: DropdownButton(
                              // Initial Value
                              value: auth.driverOrganization?.uid,
                              hint: const Text("Organization"),
                              isExpanded: true,
                              underline: Container(),

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: auth.organizations
                                  .map((Organization organization) {
                                return DropdownMenuItem(
                                  value: organization.uid,
                                  child: Text(organization.name),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (newValue) {
                                setState(() {
                                  // dropdownvalue = newValue!;
                                  auth.driverOrganization = auth.organizations
                                      .where((org) => org.uid == newValue)
                                      .toList()[0];
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomTextField(
                          onPressed: () {},
                          textController: auth.numberPlateController,
                          hintText: "Number plate",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    )),
                    greenButton(
                      label: "Sign Up",
                      onPressed: () async {
                        await auth.editDetails();

                        await context.read<AuthProvider>().addJobDetails();
                        auth.signUpComplete = true;
                        auth.signUpState = 1;
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
