import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:plango/utilities/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlaceDetailPage extends StatefulWidget {
  const PlaceDetailPage({Key? key}) : super(key: key);

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

// 클릭한 이벤트의 상세 내용을 볼 수 있는 페이지입니다
// 구글맵 추가 완료
class _PlaceDetailPageState extends State<PlaceDetailPage> {
  late GoogleMapController _controller;
  final Set<Marker> markers = {};
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance;

  void addMarker(coordinate) {
    setState(() {
      markers.add(Marker(
        position: coordinate,
        markerId: MarkerId("0"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Event e = ModalRoute.of(context)!.settings.arguments as Event;
    addMarker(LatLng(e.getLat(), e.getLng()));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black87),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:10),
              child: LikeButton(
              ),
            )
          ],
          title: Text(
            "Event",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 1.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(e.getLat(), e.getLng()),
                    zoom: 15.0,
                  ),
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      _controller = controller;
                    });
                  },
                ),
              ),
              Row(                                                  //제목
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person),
                    Text(" Profile",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ]
              ),

              SizedBox(height:30),
              Row(
                //제목
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.menu_book),
                    Text(" Title",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ]),
              Padding(
                //위치 정보
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(e.getTitle(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 14,
                    )),
              ),
              SizedBox(height: 30),
              Row(
                //위치
                  mainAxisAlignment: MainAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Icon(Icons.location_on),
                    // ignore: prefer_const_constructors
                    Text(" Location",
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ]),
              SizedBox(height: 10),
              Padding(
                //위치 정보
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(e.getLocation()!,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "GmarketSansTTF",
                      fontSize: 14,
                    )),
              ),
              SizedBox(height: 30),
              Row(
                //일정시작
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time_filled),
                    Text(" Time",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ]),
              SizedBox(height: 10),

              SizedBox(height: 30),
              Row(
                //유형
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.textsms),
                    Text(" Type",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ]),
              SizedBox(height: 10),



              SizedBox(height: 30),
              Row(
                //이미지
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.camera_alt),
                    Text(" Images",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ]),

              SizedBox(height: 30),
              Row(
                //주제
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.tag),
                    Text(" HashTag",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ]),
              SizedBox(height: 10),

              SizedBox(height: 20),
              Center(
                  child: ElevatedButton(
                    child: Text(
                      "Add To My Tour",
                      style: TextStyle(
                        fontFamily: "GmarketSansTTF",
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(e);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                    )
                  )
              )
            ],
          ),
        ));
  }
}
