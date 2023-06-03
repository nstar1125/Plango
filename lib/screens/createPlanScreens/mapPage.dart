import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

const kGoogleApiKey = "AIzaSyA_vu6zRJghC1YDnXof22ROP5r85mwtK4c";

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // related google map
  static const CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(37.5052, 126.9571), zoom: 14.0);
  final Set<Marker> _marker = {};
  late GoogleMapController _controller;

  // related google place
  final Mode _mode = Mode.overlay;
  late PlacesDetailsResponse detail;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset : false,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _marker,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
        ],
      )
    );
  }
}
