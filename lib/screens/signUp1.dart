import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:shutt_app_driver/providers/authProvider.dart';
import 'package:shutt_app_driver/screens/signUp2.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:shutt_app_driver/widgets/greenButton.dart';
import 'package:shutt_app_driver/widgets/headingText.dart';
import 'package:shutt_app_driver/widgets/customTextField.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shutt_app_driver/models/User.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({Key? key}) : super(key: key);

  @override
  State<SignUp1> createState() => _SignUp1State();
}

class _SignUp1State extends State<SignUp1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  const HeadingText(
                    text: "Enter your number",
                    alignment: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Row(
                    children: [
                      const Text(
                        "+233",
                        style: TextStyle(
                          fontSize: 20,
                          color: appColors.green,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: CustomTextField(
                            onPressed: () {},
                            textController: auth.phoneNumController,
                            hintText: "— —  — — —  — — — —",
                            keyboardType: TextInputType.number),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  greenButton(
                    label: "Sign In",
                    onPressed: () async {
                      try {
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        await _auth
                            .verifyPhoneNumber(
                          phoneNumber:
                              "+233${auth.phoneNumController.text.trim()}",
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                            UserCredential value =
                                await _auth.signInWithCredential(credential);
                            if (value.user != null) {
                              print("User Signed in!");
                            }
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            if (e.code == 'invalid-phone-number') {
                              print('The provided phone number is not valid.');
                            }
                          },
                          codeSent:
                              (String verificationId, int? resendToken) async {
                            String smsCode = 'xxxx';
                            auth.verificationId = verificationId;
                            print("Verification Id = ${verificationId}");
                          },
                          codeAutoRetrievalTimeout: (String resendToken) {},
                          timeout: const Duration(seconds: 60),
                        )
                            .then((value) {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const SignUp2()));
                          auth.signUpState = 2;
                        });
                      } catch (e) {
                        print(e.toString());
                        return "";
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 2.0,
                          color: appColors.green,
                        ),
                      ),
                      const Expanded(
                          flex: 1,
                          child: Text(
                            "OR",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: appColors.green),
                          )),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 2.0,
                          // width: 130.0,
                          color: appColors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: appColors.lightGreen)),
                        // padding: const EdgeInsets.all(10.0),
                        child: TextButton(
                            onPressed: () async {
                              User userObj = await context
                                  .read<AuthService>()
                                  .googleLogin();
                              context.read<AuthProvider>().setUser(userObj);
                              context.read<AuthProvider>().signUpState = 4;
                              // Provider.of<AuthProvider>(context, listen: false)
                              // .setUser(userObj);
                              // Provider.of<AuthProvider>(context, listen: false)
                              // .signUpState = 4;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  FontAwesomeIcons.google,
                                  color: appColors.lightGreen,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "Sign in with Google",
                                  style: TextStyle(color: appColors.lightGreen),
                                )
                              ],
                            )),
                      ))
                    ],
                  ),
                ],
              )),
              const Text(
                "If you are creating a new account, Terms & Conditions and Privacy Policy will apply",
                textAlign: TextAlign.center,
                style: TextStyle(color: appColors.textGrey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
