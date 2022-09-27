import 'package:flutter/material.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:shutt_app_driver/widgets/rideInfoItem.dart';

class RideInfo2 extends StatelessWidget {
  final String promptText;
  const RideInfo2({Key? key, required this.promptText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: appColors.appWhite,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.bus_alert,
                    size: 32,
                    color: appColors.green,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    "GA-1234-56",
                    style: TextStyle(
                        fontSize: 28,
                        color: appColors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                color: appColors.green,
              ),
              Text(
                promptText,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: appColors.green),
              ),
              const SizedBox(
                height: 12,
              ),
              const RideInfoItem(
                keyText: "Pickup point: ",
                valueText: "Hilla Limann Hostel",
                valueSize: 16,
                valueWeight: FontWeight.w300,
                valueColor: appColors.darkGreen,
              ),
              const SizedBox(
                height: 12,
              ),
              const RideInfoItem(
                keyText: "Dropoff point: ",
                valueText: "GCB main auditorium",
                valueSize: 16,
                valueWeight: FontWeight.w300,
                valueColor: appColors.darkGreen,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fare:",
                    style: TextStyle(color: appColors.green, fontSize: 12),
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
      ),
    );
  }
}
