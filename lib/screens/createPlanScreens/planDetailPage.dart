import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plango/utilities/event.dart';

class PlanDetailPage extends StatefulWidget {
  const PlanDetailPage({Key? key}) : super(key: key);

  @override
  State<PlanDetailPage> createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends State<PlanDetailPage> {
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance;
  late GoogleMapController _controller;
  final List<Set<Marker>> markersList = [];

  String planTitle = "";
  List<bool> showList = [];
  List<String> dateList = [];
  List<String> timeList = [];
  int eventCount = 100;

  List<String> placeIdList = [];
  List<Event> events = [];

  AsyncMemoizer memory = AsyncMemoizer();

  _PlanDetailPageState() {
    for (int i = 0; i < eventCount; i++) {
      showList.add(false);
      dateList.add("날짜 선택");
      timeList.add("시간 선택");
    }
  }
  listUpdate(){
    for (int i = eventCount; i < 100; i++) {
      showList.removeAt(eventCount);
      dateList.removeAt(eventCount);
      timeList.removeAt(eventCount);
    }
  }

  void addMarker(coordinate) {
    setState(() {
      Set<Marker> markers = {};
      markers.add(Marker(
        position: coordinate,
        markerId: MarkerId("0"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
      markersList.add(markers);
    });
  }

  getTrueCount(List<bool> arr) {
    int count = 0;
    for (int i = 0; i < eventCount; i++) arr[i] ? count++ : null;
    return count;
  }

  showAlertMsg(String msg){
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(msg),
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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => listUpdate()); //빌드 후 실행
  }
  @override
  Widget build(BuildContext context) {
    memory.runOnce((){
      events =
        ModalRoute.of(context)!.settings.arguments as List<Event>;
      for (int i = 0; i < events.length; i++) {
        placeIdList.add(events[i].getPlaceId());
        addMarker(LatLng(events[i].getLat(), events[i].getLng()));
      }
      eventCount = events.length;
    });
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).unfocus();
      }),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.map),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                    width: 3,
                    height: showList[eventCount - 1]
                        ? 100 * eventCount.toDouble() +
                            300 * (getTrueCount(showList) - 1)
                        : 100 * eventCount.toDouble() +
                            300 * getTrueCount(showList),
                    color: Theme.of(context).primaryColor),
              ),
              Column(
                children: [
                  Container(
                      height: 100 * (eventCount.toDouble() + 1) +
                          300 * getTrueCount(showList),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: eventCount,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showList[index]
                                          ? showList[index] = false
                                          : showList[index] = true;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Container(
                                                    color: Colors.white,
                                                    child: Icon(
                                                      Icons.circle,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    )),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 15),
                                                  Text(
                                                    events[index].getTitle(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline1,
                                                  ),
                                                  Row(
                                                    //일정 시작 버튼 2개
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            elevation: 0,
                                                            backgroundColor:
                                                                Colors.white),
                                                        onPressed: () {
                                                          DatePicker.showDatePicker(
                                                              context,
                                                              theme:
                                                                  DatePickerTheme(
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              minTime: DateTime(
                                                                  2000, 1, 1),
                                                              maxTime: DateTime(
                                                                  2023, 12, 31),
                                                              onConfirm: (date) {
                                                            dateList[index] =
                                                                '${date.year} - ${date.month} - ${date.day}';
                                                            setState(() {});
                                                          },
                                                              currentTime:
                                                                  DateTime.now(),
                                                              locale:
                                                                  LocaleType.en);
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 50.0,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    child: Text(
                                                                      dateList[
                                                                          index],
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black87,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            elevation: 0,
                                                            backgroundColor:
                                                                Colors.white),
                                                        onPressed: () {
                                                          DatePicker.showTimePicker(
                                                              context,
                                                              theme:
                                                                  DatePickerTheme(
                                                                containerHeight:
                                                                    210.0,
                                                              ),
                                                              showTitleActions:
                                                                  true,
                                                              onConfirm: (time) {
                                                            timeList[index] =
                                                                '${time.hour} : ${time.minute}';
                                                            setState(() {});
                                                          },
                                                              currentTime:
                                                                  DateTime.now(),
                                                              locale:
                                                                  LocaleType.en);
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 50.0,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Text(
                                                                  timeList[index],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ]),
                                      ],
                                    ),
                                  ),
                                ),
                                showList[index]
                                    ? Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        height: 300,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color.fromARGB(
                                                255, 239, 239, 239)),
                                        width: MediaQuery.of(context).size.width -
                                            80,
                                        child: ListView(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              height: 120,
                                              child: GoogleMap(
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: LatLng(
                                                      events[index].getLat(),
                                                      events[index].getLng()),
                                                  zoom: 15.0,
                                                ),
                                                zoomGesturesEnabled: false,
                                                zoomControlsEnabled: false,
                                                markers: markersList[index],
                                                onMapCreated: (GoogleMapController
                                                    controller) {
                                                  setState(() {
                                                    _controller = controller;
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Center(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                child: Text(
                                                    events[index].getLocation()!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    )),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                                height: 120,
                                                child: Hero(
                                                  tag: 'imagetag1',
                                                  child: events[index].getImageData() != null ? Image.memory(
                                                      events[index].getImageData()!
                                                  ) : Container(child: Center(child: Text("이미지 없음"),),),
                                                )
                                            ),

                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            );
                          })),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        width: 320,
                        height: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 239, 239, 239)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.edit),
                                    Text("이번 일정의 제목을 붙여주세요!",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "GmarketSansTTF",
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextField(
                                onChanged: (value) {
                                  planTitle = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: "일정 제목",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      print(dateList);
                      if(dateList.contains("날짜 선택") || timeList.contains == "시간 선택"){
                        showAlertMsg("날짜와 시간을 선택하세요.");
                      }else if(planTitle==""){
                        showAlertMsg("일정 제목을 입력하세요.");
                      }else{
                        Plan myPlan = new Plan(planTitle,events,dateList,timeList);
                        final plan = <String, dynamic>{
                          "plannerId": currentUser.currentUser!.uid,
                          "title": planTitle,
                          "dateList": dateList,
                          "timeList": timeList,
                          "eventList": placeIdList
                        };

                        db.collection("plans").add(plan);

                        Navigator.of(context).pushReplacementNamed('/toPlanCheckPage', arguments: myPlan);
                      }
                    },
                    child: Text("일정 저장하기"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
