import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:shutt_app_driver/widgets/rideInfoItem.dart';

class TripInfo extends StatelessWidget {
  final String regNumber;
  const TripInfo({Key? key, required this.regNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.appWhite,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.bus,
                  size: 32,
                  color: appColors.green,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  regNumber,
                  style: const TextStyle(
                      fontSize: 28,
                      color: appColors.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Next stop :",
                  style: TextStyle(color: appColors.green, fontSize: 16),
                ),
                Row(
                  children: const [
                    Text("GHc",
                        style: TextStyle(
                            color: appColors.darkGreen,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    Text("1.30",
                        style: TextStyle(
                            color: appColors.darkGreen,
                            fontSize: 28,
                            fontWeight: FontWeight.normal))
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
