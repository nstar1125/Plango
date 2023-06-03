import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:io' show Platform;

const GoogleApiKey_android = "AIzaSyA_vu6zRJghC1YDnXof22ROP5r85mwtK4c";
const GoogleApiKey_ios = "AIzaSyAyajOJaBC7Meua_8-Sf68sZuAirVS8CWE";

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

  // related google place
  final Mode _mode = Mode.overlay;
  late PlacesDetailsResponse detail;

  _getCurrentLocation() async{
    myPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    if(mounted)
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
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: _handlePressButton,
              icon: Icon(CupertinoIcons.search)
          )
        ],
      ),
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    child: Text("경로 추천"),
                    onPressed: (){
                      Navigator.pushNamed(context, "/toPreferencePage");
                    },
                ),
                ElevatedButton(
                  child: Text("경로 검색"),
                  onPressed: (){

                  },
                )
              ],
            ),
          )
        ],
      )
    );
  }
  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: (Platform.isAndroid)?GoogleApiKey_android:GoogleApiKey_ios,
      onError: onError,
      mode: _mode,
      language: "kr",
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: '장소를 입력하세요',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "kr")],
    );
    if(p!=null)
      displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {}

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: (Platform.isAndroid)?GoogleApiKey_android:GoogleApiKey_ios,
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

    detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    _marker.clear();
    _marker.add(Marker(markerId: const MarkerId("0"), position: LatLng(lat, lng), infoWindow: InfoWindow(title: detail.result.name)));

    setState(() {});

    _controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16.0));

  }
}
