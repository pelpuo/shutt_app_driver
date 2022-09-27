import 'package:awesome_icons/awesome_icons.dart';
import "package:flutter/material.dart";
import 'package:shutt_app_driver/services/dbService.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:shutt_app_driver/widgets/customTextField.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/providers/mapProvider.dart';
import 'package:shutt_app_driver/models/Stop.dart';

class LocationSet extends StatefulWidget {
  const LocationSet({Key? key}) : super(key: key);

  @override
  State<LocationSet> createState() => LocationSetState();
}

class LocationSetState extends State<LocationSet> {
  TextEditingController pickupPoint = TextEditingController();
  TextEditingController dropoffPoint = TextEditingController();

  late FocusNode pickUpFocusNode;
  late FocusNode dropOffFocusNode;

  List<Stop> stops = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickUpFocusNode = FocusNode();
    dropOffFocusNode = FocusNode();

    pickUpFocusNode.requestFocus();
    // stops = Provider.of<MapProvider>(context, listen: false).getStops();
    retrieveStops();
  }

  retrieveStops() async {
    List<Stop> temp = await context.read<dbService>().retrieveStops();
    // print(temp);
    setState(() {
      stops = temp;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pickUpFocusNode.dispose();
    dropOffFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Icon(
          Icons.arrow_back,
          color: appColors.green,
        ),
        elevation: 0,
      ),
      body: Consumer<MapProvider>(
        builder: (context, map, child) => Column(children: [
          Material(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12.0, left: 12, bottom: 16, right: 12),
              child: Column(
                children: [
                  CustomTextField(
                      focusNode: pickUpFocusNode,
                      onPressed: () {
                        map.locationTextState = "pickUp";
                      },
                      textController: map.pickUpPointController,
                      hintText: "Pickup point"),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                      focusNode: dropOffFocusNode,
                      onPressed: () {
                        map.locationTextState = "dropOff";
                      },
                      textController: map.dropOffPointController,
                      hintText: "Dropoff point")
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Flexible(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: stops.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      onTap: () {
                        if (map.locationTextState == 'pickUp') {
                          map.pickUpPointController.text = stops[index].name;
                          map.pickupPoint = stops[index];

                          pickUpFocusNode.unfocus();
                          dropOffFocusNode.requestFocus();
                          map.locationTextState = 'dropOff';

                          dropOffFocusNode.requestFocus();
                        } else if (map.locationTextState == 'dropOff') {
                          map.dropOffPointController.text = stops[index].name;
                          map.dropOffPoint = stops[index];

                          map.locationTextState = '';
                        }

                        if (map.pickUpPointController.text != "" &&
                            map.dropOffPointController.text != "" &&
                            map.locationTextState == "") {
                          Navigator.pop(context);
                        }
                      },
                      leading: const Icon(FontAwesomeIcons.mapMarkerAlt),
                      title: Text(stops[index].name));
                }),
          ),
        ]),
      ),
    );
  }
}
