import 'package:flutter/material.dart';
import 'package:shutt_app_driver/widgets/NavigationDrawer.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _SettingsState();
}

class _SettingsState extends State<About> {
  final Uri _url = Uri.parse("https://enactusug.org/");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About"),
          foregroundColor: appColors.green,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: appColors.green),
        ),
        drawer: const NavigationDrawer(),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              child: Column(children: [
                Divider(),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/enactus_logo.png',
                      width: 120,
                    ),
                    Image.asset(
                      'assets/shuttApp_logo.png',
                      width: 96,
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "About ShuttApp",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: appColors.green),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  '''ShuttApp is a mobile app that allows students to know the precise location and route of each shuttle in order for them to gain enough confidence to choose the shuttle services over alternative means of transportation such as the expensive taxis or the time consuming-walking.
        
More importantly, the app allows bus drivers/ conductors to monitor the number of students at each stop, leading to a better estimate of the amount of time needed to be spent at each stop while waiting for passengers.
        
ShuttApp was developed by Enactus University of Ghana which is an experiential learning platform which helps students unleash their entrepreneurial spirit and develop the talent and perspective essential to leadership in our ever-changing world.
                  ''',
                  style: TextStyle(fontSize: 16, color: Color(0xff343434)),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Mission",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: appColors.green),
                ),
                const Text(
                  "Engage the next generation of entrepreneurial leaders to use innovation and business principles toimprove the world.",
                  style: TextStyle(fontSize: 16, color: Color(0xff343434)),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Vision",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: appColors.green),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "To create a better, more sustainable world.",
                    style: TextStyle(fontSize: 16, color: Color(0xff343434)),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                        backgroundColor:
                            MaterialStateProperty.all(appColors.lightGreen)),
                    onPressed: () async {
                      if (!await launchUrl(_url))
                        print('Could not launch $_url');
                    },
                    child: const Text(
                      "Discover More",
                      style: TextStyle(fontSize: 18, color: appColors.appWhite),
                    )),
                const SizedBox(
                  height: 36,
                ),
                const Text("Copyright: Enactus UG, 2022",
                    style: TextStyle(color: appColors.textGrey)),
              ]),
            ),
          ),
        ));
  }
}
