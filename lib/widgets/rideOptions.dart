import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/providers/mapProvider.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:shutt_app_driver/widgets/customTextField2.dart';
import 'package:shutt_app_driver/screens/locationSet.dart';

class RideOptions extends StatelessWidget {
  final TextEditingController pickupController;
  final TextEditingController dropoffController;
  final Function goPressed;
  const RideOptions(
      {Key? key,
      required this.pickupController,
      required this.goPressed,
      required this.dropoffController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Material(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            elevation: 1,
            child: Container(
                padding: const EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                // color: appColors.appWhite,
                child: Container(
                  width: MediaQuery.of(context).size.width - 64,
                  child: Column(
                    children: [
                      CustomTextField2(
                        onPressed: () {
                          Provider.of<MapProvider>(context, listen: false)
                              .locationTextState = 'pickUp';
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LocationSet()));
                        },
                        textIcon: FontAwesomeIcons.mapMarkerAlt,
                        textController: pickupController,
                        readOnly: true,
                        hintText: "Select pick up point",
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextField2(
                        onPressed: () {
                          Provider.of<MapProvider>(context, listen: false)
                              .locationTextState = 'dropOff';
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LocationSet()));
                        },
                        textIcon: FontAwesomeIcons.mapPin,
                        textController: dropoffController,
                        readOnly: true,
                        hintText: "Select drop off point",
                      ),
                    ],
                  ),
                )),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Material(
                  elevation: 1,
                  color: appColors.appWhite,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(appColors.appWhite)),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(
                            FontAwesomeIcons.clock,
                            color: appColors.green,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            "Depart at:",
                            style: TextStyle(color: appColors.textGrey),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Now",
                            style: TextStyle(color: appColors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                  flex: 1,
                  child: Material(
                    elevation: 1,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(appColors.appWhite)),
                      onPressed: () {
                        goPressed();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "Go",
                          style: TextStyle(
                              color: appColors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Material(
            elevation: 1,
            color: appColors.appWhite,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Fare:",
                      style: TextStyle(
                          color: appColors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Row(
                    children: const [
                      Text("GHC",
                          style: TextStyle(
                              color: appColors.textBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(
                        width: 8,
                      ),
                      Text("-- --",
                          style: TextStyle(
                              color: appColors.textGrey, fontSize: 18)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
