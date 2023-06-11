import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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

class ShowAutoPathPage extends StatefulWidget {
  const ShowAutoPathPage({Key? key}) : super(key: key);

  @override
  State<ShowAutoPathPage> createState() => _ShowAutoPathPageState();
}

class _ShowAutoPathPageState extends State<ShowAutoPathPage> {
  // related google map
  Position? myPosition;
  Set<Marker> markers = {};
  static int markerId = 1;
  late GoogleMapController _controller;
  Set<Polyline> polyline = {};
  List<LatLng> points = [];

  // related google place
  final Mode _mode = Mode.overlay;
  late PlacesDetailsResponse detail;

  List<Event> events = [];
  bool firstBuild = true;


  // 마커 이미지
  List<String> images = ['assets/images/marker1.png','assets/images/marker2.png',
    'assets/images/marker3.png', 'assets/images/marker4.png',
    'assets/images/marker5.png', 'assets/images/marker6.png'];

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
                  return CupertinoAlertDialog(
                    title: const Text("일정에서 제거하시겠습니까?"),
                    actions: [
                      CupertinoButton(
                        child: const Text("취소"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoButton(
                        child: Text("삭제",
                            style: TextStyle(color: Colors.red,)),
                        onPressed: () async {
                          markers.clear();
                          points.remove(coordinate);
                          markers.removeWhere((marker) => marker.markerId.value == (points.indexOf(coordinate)+1).toString());
                          events.removeWhere((event) => LatLng(event.getLat(), event.getLng()) == coordinate);
                          markerId = 1;
                          for(int i = 0; i < points.length; i++){
                            await addMarker(points[i]);
                          }
                          print(points);
                          print(events);
                          setState(() { });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
            );
          }
      ));
    });
    markerId++;
  }

  showAlertMsg(){
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("일정을 하나 이상 선택하세요!"),
            actions: [
              CupertinoButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  buildPath() async{
    markers.removeWhere((marker) => marker.markerId.value == "0");
    for(int i = 0; i<events.length; i++){
      points.add(LatLng(events[i].getLat(), events[i].getLng()));
      polyline.add(Polyline(
        patterns: [
          PatternItem.dash(30),
          PatternItem.gap(20),
        ],
        polylineId: const PolylineId('0'),
        points: points,
        color: Theme.of(context).accentColor,
      ));
      //set state 포함
      await addMarker(LatLng(events[i].getLat(), events[i].getLng()));
    }
  }

  @override
  void initState() {
    super.initState();
    markerId = 1;
  }

  @override
  Widget build(BuildContext context) {
    events = ModalRoute.of(context)!.settings.arguments as List<Event>;
    if (firstBuild){
      buildPath();
      firstBuild = false;
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.black
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,

        ),
        key: homeScaffoldKey,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset : false,
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(events[0].getLat(), events[0].getLng()), zoom: 14.0),
              markers: markers,
              polylines: polyline,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _controller = controller;
                });
                _controller.animateCamera(CameraUpdate.newLatLng(LatLng(events[-1].getLat(), events[-1].getLng())));
              },
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor
                      ),
                      child: Text("일정 생성하기"),
                      onPressed: (){
                        if(!events.isEmpty){
                          Navigator.of(context).pushNamed('/toPlanDetailPage', arguments: events);
                        }else{
                          showAlertMsg();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20)
                ]
            ),
          ],
        )
    );
  }
}


