import 'package:flutter/material.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:shutt_app_driver/widgets/NavigationDrawer.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: appColors.darkGreen),
      ),
      drawer: const NavigationDrawer(),
      body: const Center(
        child: Text("Settings Screen"),
      ),
    );
  }
}
