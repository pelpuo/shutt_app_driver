// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Providers
import 'package:shutt_app_driver/providers/authProvider.dart';
import 'package:shutt_app_driver/providers/mapProvider.dart';
import 'package:shutt_app_driver/screens/authWrapper.dart';

// Screens
import 'package:shutt_app_driver/screens/home.dart';
import 'package:shutt_app_driver/screens/home2.dart';
import 'package:shutt_app_driver/screens/rateRide.dart';
import 'package:shutt_app_driver/screens/signUp2.dart';
import 'package:shutt_app_driver/screens/signUp3.dart';
import 'package:shutt_app_driver/screens/signUp1.dart';
import 'package:shutt_app_driver/screens/signUp4.dart';
import 'package:shutt_app_driver/services/authService.dart';
import 'package:shutt_app_driver/services/dbService.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        Provider<dbService>(
          create: (_) => dbService(),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => MapProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ShuttApp Driver",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
