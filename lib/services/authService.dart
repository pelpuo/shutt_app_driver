import 'package:firebase_auth/firebase_auth.dart';
import 'package:shutt_app_driver/models/User.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/providers/authProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  String verificationId = "";

  GoogleSignInAccount? _gUser;

  GoogleSignInAccount get gUser => _gUser!;

  // auth change user stream
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  printUser() {
    // _auth.currentUser?.updateDisplayName("John Doe");
    // print("Current User: $_auth.currentUser");
    // return _auth.currentUser;
  }

  // Sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result;
    } catch (e) {
      print(e.toString());
      return Null;
    }
  }

  // Verify phone number
  Future<String?> verifyPhone({required String phoneNumber}) async {
    String verificationID = "";
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+233$phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential value = await _auth.signInWithCredential(credential);
          if (value.user != null) {
            print("User Signed in!");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          String smsCode = 'xxxx';
          verificationID = verificationId;
          print("Verification Id = ${verificationId}");
        },
        codeAutoRetrievalTimeout: (String resendToken) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  // Sign in with phone
  Future signInWithPhone(String verificationId, String smsCode) async {
    try {
      UserCredential value = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode));
      return value.user;
    } catch (e) {
      print(e.toString());
    }
  }

  // Sign in with google
  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;
      _gUser = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential result = await _auth.signInWithCredential(credential);

      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  // Edit user credentials
  Future editCredentials(
      {String firstName = "", String lastName = "", String email = ""}) async {
    try {
      if (firstName != "" && lastName != "") {
        await _auth.currentUser?.updateDisplayName("$firstName $lastName");
      }
      if (email != "") {
        await _auth.currentUser?.updateEmail(email);
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
