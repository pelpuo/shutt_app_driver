import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shutt_app_driver/screens/about.dart';
import 'package:shutt_app_driver/screens/authWrapper.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:shutt_app_driver/screens/profile.dart';
import 'package:shutt_app_driver/screens/settings.dart';
import 'package:shutt_app_driver/screens/home.dart';
import 'package:provider/provider.dart';

import '../services/authService.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: appColors.appWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(context),
          const Divider(
            color: appColors.textGrey,
          ),
          Expanded(child: buildMenuItems(context)),
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Powered by Enactus UG",
                style: TextStyle(color: appColors.textGrey),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        color: appColors.appWhite,
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              left: 24,
              right: 24,
              bottom: 16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const CircleAvatar(
              radius: 26,
              backgroundColor: appColors.offWhite,
              backgroundImage: NetworkImage(
                  "https://cambridgetamilchurch.com/wp-content/uploads/2016/04/human-icon-1.png"),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.read<User?>()?.displayName?.split(" ")[0] ?? "",
                  style: const TextStyle(
                      color: appColors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Text(
                  context.read<User?>()?.email ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    color: appColors.textGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
          ]),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Wrap(runSpacing: 16, children: [
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
              color: appColors.lightGreen,
            ),
            title: Text(
              'Home',
              style: iconTextStyle,
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: appColors.lightGreen,
            ),
            title: Text(
              'Profile',
              style: iconTextStyle,
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Profile()));
            },
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.settings,
          //     color: appColors.lightGreen,
          //   ),
          //   title: Text(
          //     'Settings',
          //     style: iconTextStyle,
          //   ),
          //   onTap: () {
          //     Navigator.pushReplacement(context,
          //         MaterialPageRoute(builder: (context) => const Settings()));
          //   },
          // ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: appColors.lightGreen,
            ),
            title: Text(
              'About',
              style: iconTextStyle,
            ),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const About()));
            },
          ),
          const Divider(
            color: appColors.textGrey,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: appColors.lightGreen,
            ),
            title: Text(
              'Logout',
              style: iconTextStyle,
            ),
            onTap: () async {
              await context.read<AuthService>().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AuthWrapper()));
            },
          ),
        ]),
      );

  TextStyle iconTextStyle = const TextStyle(
    color: appColors.textBlack,
  );
}
