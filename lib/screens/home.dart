import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shutt_app_driver/providers/mapProvider.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:shutt_app_driver/widgets/NavigationDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shutt_app_driver/widgets/coloredButton.dart';
import 'package:shutt_app_driver/widgets/customTextField.dart';
import 'package:shutt_app_driver/widgets/greenButton.dart';
import 'package:shutt_app_driver/widgets/rideInfo1.dart';
import 'package:shutt_app_driver/widgets/rideInfo2.dart';
import 'package:shutt_app_driver/widgets/rideOptions.dart';
import 'package:provider/provider.dart';
import 'package:shutt_app_driver/widgets/tripInfo.dart';

import '../models/Bus.dart';
import '../models/Stop.dart';
import '../services/dbService.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  // static const _initialCameraPosition =
  //     CameraPosition(target: LatLng(5.6506, -0.1962), zoom: 15.5);
  GoogleMapController? _googleMapController;

  TextEditingController pickupController = TextEditingController();
  TextEditingController dropoffController = TextEditingController();

  Location location = Location();
  CameraPosition? initialCameraPosition;
  bool cameraPositionSet = true;

  List<Bus> buses = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
  }

  getUserLocation() async {
    LocationData userPosition = await location.getLocation();
    print("User position: $userPosition");
    setState(() {
      initialCameraPosition = CameraPosition(
          target: LatLng(userPosition.latitude ?? 5.6506,
              userPosition.longitude ?? -0.1962),
          zoom: 17);

      cameraPositionSet = true;
    });
  }

  addBusMarkers() async {
    List<Bus> temp = await context.read<dbService>().retrieveBuses();
    print(temp);
    // setState(() {
    //   buses = temp;
    // });
    for (Bus bus in temp) {
      LatLng latLng = new LatLng(bus.location.latitude, bus.location.longitude);
      await Provider.of<MapProvider>(context, listen: false)
          .addMarker(latLng, bus.registrationNumber);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final map = context.watch<MapProvider>();
    return Scaffold(
      drawer: const NavigationDrawer(),
      key: scaffoldKey,
      body: Consumer<MapProvider>(
        builder: (context, map, child) => Stack(
          children: [
            cameraPositionSet
                ? GoogleMap(
                    // initialCameraPosition: initialCameraPosition!,
                    initialCameraPosition: const CameraPosition(
                        target: LatLng(5.64611816448952, -0.18688324465950523),
                        zoom: 15),
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    markers: map.markers,
                    myLocationEnabled: true,
                    onMapCreated: map.onMapCreated,
                    // polylines: map.polylines,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            padding: const EdgeInsets.all(12),
                            shape: const CircleBorder(),
                            color: appColors.appWhite,
                            elevation: 2,
                            child: const Icon(
                              Icons.menu,
                              color: appColors.green,
                            ),
                            onPressed: () =>
                                scaffoldKey.currentState?.openDrawer(),
                          ),
                          MaterialButton(
                            color: appColors.appWhite,
                            elevation: 2,
                            padding: const EdgeInsets.all(12),
                            shape: const CircleBorder(),
                            child: const Icon(Icons.my_location,
                                color: appColors.green),
                            onPressed: () async {
                              await map.animateCamera();
                            },
                          )
                        ]),
                    !map.tripStarted
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: greenButton(
                                label: "Start Trip",
                                onPressed: () {
                                  map.startTrip();
                                }),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              color: appColors.appWhite,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.bus,
                                            size: 28,
                                            color: appColors.green,
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            map.driverBus?.registrationNumber ??
                                                "",
                                            style: const TextStyle(
                                                fontSize: 24,
                                                color: appColors.textBlack,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        "Trip Started",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: appColors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text("Trip has Begun",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: appColors.green,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  coloredButton(
                                      elevation: 0,
                                      label: "End Trip",
                                      color: appColors.lightGreen,
                                      textColor: appColors.appWhite,
                                      onPressed: () {
                                        // map.addStopMarkers();
                                        map.stopTrip();
                                      }),
                                ],
                              ),
                            )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onGoPressed(MapProvider map) async {
    // await context.watch<dbService>().trackBus(bus);
  }
}
