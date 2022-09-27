import 'package:flutter/material.dart';
import 'package:shutt_app_driver/styles/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(5.6506, -0.1962), zoom: 15.5);
  GoogleMapController? _googleMapController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }
}
