import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
  Set<Polyline> polyline = {};
  List<LatLng> points = [];

  // related google place
  final Mode _mode = Mode.overlay;
  late PlacesDetailsResponse detail;

  //container change bool
  bool isClickedPersonally = false;
  bool hasSearched = false;
  bool isShow = false;
  bool widgetShow = false;

  String _date = "날짜 선택";
  String _time = "시간 선택";
  List<Event> events = [];

  // 마커 이미지
  List<String> images = ['assets/images/marker1.png','assets/images/marker2.png',
    'assets/images/marker3.png', 'assets/images/marker4.png',
    'assets/images/marker5.png', 'assets/images/marker6.png'];
  List<Image> disable_type_image = [
    Image.asset('assets/images/disabled.png'),
    Image.asset('assets/images/body.png'),
    Image.asset('assets/images/blind.png'),
    Image.asset('assets/images/deaf.png'),
    Image.asset('assets/images/baby.png'),
  ];
  List<Image> sel_type_image = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    disable_type_image.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.only(top:10, left: 5, right: 5, bottom: 5),
        child: ChoiceChip(
          selectedColor: Theme.of(context).primaryColor,
          label: Container(
              width: 35,
              height: 50,
              child: item

          ),
          selected: sel_type_image.contains(item),
          onSelected: (selected) {
            setState(() {
              sel_type_image.contains(item)
                  ? sel_type_image.remove(item)
                  : sel_type_image.add(item);
            });
          },
        ),
      ));
    });
    return choices;
  }

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
                          setState(() {});
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
          Container(
            margin: EdgeInsets.only(top:10, right: 10),
            width: 45,
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30)
            ),
            child: IconButton(
                onPressed: _handlePressButton,
                icon: Icon(CupertinoIcons.search,
                  color: Colors.white,
                )
            ),
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
            markers: markers,
            polylines: polyline,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ) :Center(child: CircularProgressIndicator(),),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (!isClickedPersonally)
                  ?Container(
                child: (hasSearched)
                    ?Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                          child: Text("경로 추천"),
                          onPressed: (){
                            if(hasSearched) {
                              Navigator.pushNamed(context, "/toPreferencePage", arguments: detail.result);
                            }
                          },
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).accentColor
                          ),
                          onPressed: () {
                            isShow = true;
                            widgetShow = true;
                            if(hasSearched) {
                              isClickedPersonally = true;
                              setState(() {});
                            }
                          },
                          child: const Text("일정 작성")
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
                    :Container(),
              )
                  :AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: const EdgeInsets.only(left: 20, right:20),
                    height:isShow?220:24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                      ),
                      color: Colors.white,
                    ),
                    child: isShow
                        ?Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            widgetShow = false;
                            setState(() {
                              isShow ? isShow=false : isShow=true;
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 24,
                                width: MediaQuery.of(context).size.width/2-60,
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 10,
                                    width: 80,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    height: 4,
                                    width: 80,
                                    color: Colors.grey,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 80,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Container(
                                height: 24,
                                width: MediaQuery.of(context).size.width/2-60,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        widgetShow?Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 20),
                                child: RichText(
                                  text: TextSpan(
                                      text: "현재 ",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontFamily: "GmarketSansTTF",
                                        fontSize: 14,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${events.length} ",
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "GmarketSansTTF",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: "가지 선택됨.",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "GmarketSansTTF",
                                            fontSize: 14,
                                          ),
                                        ),
                                      ]
                                  ),)
                            ),
                            Row(                                                  //해시태그 검색
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(" # 필터",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "GmarketSansTTF",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                                ]
                            ),
                            Wrap(
                              children: _buildChoiceList(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
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
                                          addMarker(LatLng(myEvent.getLat(), myEvent.getLng()));

                                          _controller.animateCamera(CameraUpdate.newLatLng(LatLng(myEvent.getLat(), myEvent.getLng())));
                                        }
                                      });
                                    }
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).accentColor
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
                              ],
                            )
                          ],
                        ):Container()
                      ],
                    )
                        :Container(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            isShow ? isShow=false : isShow=true;
                          });
                          Timer(Duration(milliseconds: 200), () {
                            setState((){
                              widgetShow = true;
                            });
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 24,
                              width: MediaQuery.of(context).size.width/2-60,
                              color: Colors.white,
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 10,
                                  width: 80,
                                  color: Colors.white,
                                ),
                                Container(
                                  height: 4,
                                  width: 80,
                                  color: Colors.grey,
                                ),
                                Container(
                                  height: 10,
                                  width: 80,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Container(
                              height: 24,
                              width: MediaQuery.of(context).size.width/2-60,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
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
