import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:io' show Platform;
import 'package:plango/utilities/event.dart';

const GoogleApiKey_android = "AIzaSyA_vu6zRJghC1YDnXof22ROP5r85mwtK4c";
const GoogleApiKey_ios = "AIzaSyAyajOJaBC7Meua_8-Sf68sZuAirVS8CWE";

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class FromMap {
  late PlaceDetails locDetail;
  late String time;
  late List<Event> events;
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // related google map
  Position? myPosition;
  Set<Marker> markers = {};
  static int markerId = 1;
  late GoogleMapController _controller;
  List<LatLng> points = [];

  // related google place
  final Mode _mode = Mode.overlay;
  late PlacesDetailsResponse detail;

  //color
  Color recColor = Colors.grey;
  Color perColor = Colors.grey;
  Color searchColor = Colors.grey;
  Color completeColor = Colors.grey;

  //container change bool
  bool isClickedPersonally = false;
  bool hasSearched = false;
  bool isShow = true;

  String _date1 = "Choose Date";
  List<Event> events = [];

  // 마커 이미지
  List<String> images = ['assets/images/marker1.png','assets/images/marker2.png',
    'assets/images/marker3.png', 'assets/images/marker4.png',
    'assets/images/marker5.png', 'assets/images/marker6.png'];

  final currentUser = FirebaseAuth.instance;

  _getCurrentLocation() async{
    myPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    if(mounted)
      setState(() {});
  }

  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  addMarker(coordinate) async {
    final Uint8List markIcons = await getImages(images[markerId-1], 150);
    setState(() {
      markers.add(Marker(
          position: coordinate,
          markerId: MarkerId(markerId.toString()),
          icon: BitmapDescriptor.fromBytes(markIcons),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Remove ?"),
                    actions: [
                      TextButton(
                        child: const Text("YES"),
                        onPressed: () async {
                          markers.clear();
                          points.remove(coordinate);
                          markers.removeWhere((marker) => marker.markerId.value == (points.indexOf(coordinate)+1).toString());
                          events.removeWhere((event) => LatLng(event.getLat(), event.getLng()) == coordinate);

                          markerId = 1;
                          for(int i = 0; i < points.length; i++){
                            await addMarker(points[i]);
                          }


                          setState(() {});

                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("NO"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
          }
      ));
    });
    markerId++;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    markerId = 1;
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
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(37.5052, 126.9571), zoom: 14.0),
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              _controller = controller;
            });
          },

        ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: recColor,
                        elevation: 3,
                      ),
                        child: Text("경로 추천"),
                        onPressed: (){
                          Navigator.pushNamed(context, "/toPreferencePage");
                        },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: perColor,
                        elevation: 3,
                      ),
                      child: Text("근처 장소 찾기"),
                      onPressed: (){
                        if(events.length < 7){
                          var fromMapObject = FromMap();
                          fromMapObject.locDetail = detail.result;
                          fromMapObject.events = events;

                          // pop으로 전달한 arguments를 e가 받음
                          Navigator.of(context).pushNamed("/toShowPlacesPage", arguments: fromMapObject).then((e) {  //장소+키워드+시간
                            if (e != null) {
                              markers.removeWhere((marker) => marker.markerId.value == "0");

                              Event myEvent = e as Event;
                              events.add(myEvent);

                              points.add(LatLng(myEvent.getLat(), myEvent.getLng()));

                              completeColor  = Colors.lightBlueAccent;
                              //set state 포함
                              addMarker(LatLng(myEvent.getLat(), myEvent.getLng()));

                              _controller.animateCamera(CameraUpdate.newLatLng(LatLng(myEvent.getLat(), myEvent.getLng())));


                            }
                          });
                        }
                      },
                    )
                  ],
                ),
              )
            ],
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
    if(p!=null) {
      displayPrediction(p!, homeScaffoldKey.currentState);
    }
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

    recColor = Colors.white;
    perColor = Colors.lightBlueAccent;

    markers.removeWhere((marker) => marker.markerId.value == "0");

    // set State 포함
    markers.add(Marker(
      markerId: const MarkerId("0"),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: detail.result.name),
    ));

    hasSearched = true;

    setState(() {});

    _controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16.0));

  }
}
