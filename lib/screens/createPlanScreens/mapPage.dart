import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

const kGoogleApiKey = "AIzaSyA_vu6zRJghC1YDnXof22ROP5r85mwtK4c";

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // related google map
  Position? myPosition;
  final Set<Marker> _marker = {};
  late GoogleMapController _controller;


  _getCurrentLocation() async{
    myPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset : false,
      body: Stack(
        children: [
          (myPosition != null)
              ?GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(myPosition!.latitude, myPosition!.longitude), zoom: 14.0),
            markers: _marker,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          )
              :Center(child: CircularProgressIndicator(),),
        ],
      )
    );
  }
}
