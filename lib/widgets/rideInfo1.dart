import 'package:flutter/material.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:shutt_app_driver/widgets/rideInfoItem.dart';

class RideInfo1 extends StatelessWidget {
  final String promptText;
  final String pickUpPointText;
  final String dropOffPointText;
  final String busRegistrationNumber;
  const RideInfo1(
      {Key? key,
      required this.promptText,
      required this.pickUpPointText,
      required this.dropOffPointText,
      required this.busRegistrationNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, bottom: 16, left: 16),
      child: Material(
        color: appColors.appWhite,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bus_alert,
                    size: 32,
                    color: appColors.lightGreen,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    busRegistrationNumber,
                    style: const TextStyle(
                        fontSize: 28,
                        color: appColors.textBlack,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                color: appColors.green,
              ),
              RideInfoItem(
                keyText: promptText,
                valueText: "7 mins",
                valueWeight: FontWeight.bold,
                valueColor: appColors.textBlack,
              ),
              const SizedBox(
                height: 12,
              ),
              RideInfoItem(
                keyText: "Pickup point: ",
                valueText: pickUpPointText,
                valueSize: 16,
                valueWeight: FontWeight.w300,
                valueColor: appColors.textBlack,
              ),
              const SizedBox(
                height: 12,
              ),
              RideInfoItem(
                keyText: "Dropoff point: ",
                valueText: dropOffPointText,
                valueSize: 16,
                valueWeight: FontWeight.w300,
                valueColor: appColors.textBlack,
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
                      SizedBox(
                        width: 4,
                      ),
                      Text("1.50",
                          style: TextStyle(
                              color: appColors.darkGreen,
                              fontSize: 28,
                              fontWeight: FontWeight.bold))
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
