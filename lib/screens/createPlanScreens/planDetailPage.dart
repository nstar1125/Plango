import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plango/utilities/event.dart';

class PlanDetailPage extends StatefulWidget {
  const PlanDetailPage({Key? key}) : super(key: key);

  @override
  State<PlanDetailPage> createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends State<PlanDetailPage> {
  late GoogleMapController _controller;
  final List<Set<Marker>> markersList = [];

  String tourTitle = "";
  List<bool> showList = [];
  int eventCount = 100;
  _PlanDetailPageState() {
    for (int i = 0; i < eventCount; i++) {
      showList.add(false);
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


  @override
  Widget build(BuildContext context) {
    List<Event> events =
      ModalRoute.of(context)!.settings.arguments as List<Event>;
    for (int i = 0; i < events.length; i++) {
      addMarker(LatLng(events[i].getLat(), events[i].getLng()));
    }
    eventCount = events.length;

    return Scaffold(
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
                  color: Colors.lightBlueAccent),
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
                                                    Icons.circle_outlined,
                                                    color: Colors
                                                        .lightBlueAccent,
                                                  )),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 15),
                                                Text(
                                                  events[index].getTitle(),
                                                ),
                                                SizedBox(height: 15),
                                                Text("time"),
                                              ],
                                            )
                                          ]),
                                    ],
                                  ),
                                ),
                              ),
                              showList[index]
                                  ? Container(
                                height: 320,
                                color: Color.fromARGB(255, 239, 239, 239),
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
                                            left: 10, right: 10, top: 10),
                                        child: Text(
                                            events[index].getLocation()!,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: "GmarketSansTTF",
                                              fontSize: 12,
                                            )),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10),
                                          child: Text("Type:"),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, bottom: 10),
                                          child: Text("Hashtags:"),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      color: Colors.transparent,
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      child: Text(""),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )
                                  : Container()
                            ],
                          );
                        })),
                SizedBox(height: 20,),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                                tourTitle = value;
                              },
                              decoration: const InputDecoration(
                                hintText: "Tour title",
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () async {
                      if(!events.isEmpty){
                        Navigator.of(context)
                            .pushReplacementNamed('/toPlanCheckPage', arguments: events);
                      }
                    },
                    child: Text("일정 저장하기"),
                )
              ],
            ),
          ],
        ),
      ),

    );
  }
}
