import 'package:async/async.dart';
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
  late Event e;
  late GoogleMapController _controller;
  final Set<Marker> markers = {};
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance;
  AsyncMemoizer memory = AsyncMemoizer();
  List<Image> disable_type_image = [
    Image.asset('assets/images/disabled.png'),
    Image.asset('assets/images/body.png'),
    Image.asset('assets/images/blind.png'),
    Image.asset('assets/images/deaf.png'),
    Image.asset('assets/images/baby.png'),
  ];

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
    memory.runOnce((){
      e = ModalRoute.of(context)!.settings.arguments as Event;
      addMarker(LatLng(e.getLat(), e.getLng()));
    });
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
            "",
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                  Row(
                    //제목
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.menu_book),
                        Text(" 장소", style: Theme.of(context).textTheme.headline2),
                      ]),
                  Padding(
                    //위치 정보
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(e.getTitle()),
                  ),
                  SizedBox(height: 30),
                  Row(
                    //위치
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Icon(Icons.location_on),
                        // ignore: prefer_const_constructors
                        Text(" 위치",
                            // ignore: prefer_const_constructors
                            style: Theme.of(context).textTheme.headline2)
                      ]),
                  SizedBox(height: 10),
                  Padding(
                    //위치 정보
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(e.getLocation()!),
                  ),
                  SizedBox(height: 30),
                  Row(
                    //위치
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Icon(Icons.info_outline),
                        // ignore: prefer_const_constructors
                        Text(" 정보", style: Theme.of(context).textTheme.headline2)
                      ]),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left:10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: disable_type_image[0],
                            ),
                            SizedBox(width: 10),
                            Text("공용",style: Theme.of(context).textTheme.headline2)
                          ],
                        ),
                        (e.getCommonInfo()!=null)
                            ?Padding(
                              padding: const EdgeInsets.only(left:10, top:10),
                              child: Text(e.getCommonInfo()!),
                            )
                            :Container(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: disable_type_image[1],
                            ),
                            SizedBox(width: 10),
                            Text("신체 장애",style: Theme.of(context).textTheme.headline2)
                          ],
                        ),
                        (e.getDisabledInfo()!=null)
                            ?Padding(
                          padding: const EdgeInsets.only(left:10, top:10),
                          child: Text(e.getDisabledInfo()),
                        )
                            :Container(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: disable_type_image[2],
                            ),
                            SizedBox(width: 10),
                            Text("시각 장애",style: Theme.of(context).textTheme.headline2)
                          ],
                        ),
                        (e.getBlindInfo()!=null)
                            ?Padding(
                          padding: const EdgeInsets.only(left:10, top:10),
                          child: Text(e.getBlindInfo()!),
                        )
                            :Container(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: disable_type_image[3],
                            ),
                            SizedBox(width: 10),
                            Text("청각 장애",style: Theme.of(context).textTheme.headline2)
                          ],
                        ),
                        (e.getDeafInfo()!=null)
                            ?Padding(
                          padding: const EdgeInsets.only(left:10, top:10),
                          child: Text(e.getDeafInfo()!),
                        )
                            :Container(),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: disable_type_image[4],
                            ),
                            SizedBox(width: 10),
                            Text("유아 시설",style: Theme.of(context).textTheme.headline2)
                          ],
                        ),
                        (e.getBabyInfo()!=null)
                            ?Padding(
                          padding: const EdgeInsets.only(left:10, top:10),
                          child: Text(e.getBabyInfo()!),
                        )
                            :Container(),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    //유형
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.tag),
                        Text(" 유형", style: Theme.of(context).textTheme.headline2)
                      ]),
                  SizedBox(height: 10),
                  Padding(
                    //위치 정보
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(e.getCategory()!),
                  ),
                  SizedBox(height: 30),
                  Row(
                    //이미지
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.camera_alt),
                        Text(" 이미지",
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                                fontWeight: FontWeight.bold))
                      ]),
                  SizedBox(height: 10),
                  Container(
                    child: Hero(
                      tag: 'imagetag1',
                      child: e.getImageData() != null ? Image.memory(
                        e.getImageData()!
                      ) : Container(child: Center(child: Text("이미지 없음"),),),
                    )
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                    ),
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: Center(
                      child: ElevatedButton(
                        child: Text(
                          "일정 추가",
                          style: TextStyle(
                            fontFamily: "GmarketSansTTF",
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(e);
                        },
                      )
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
