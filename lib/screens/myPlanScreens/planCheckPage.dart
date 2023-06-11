import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plango/utilities/event.dart';

class PlanCheckPage extends StatefulWidget {
  const PlanCheckPage({Key? key}) : super(key: key);

  @override
  State<PlanCheckPage> createState() => _PlanCheckPageState();
}

class _PlanCheckPageState extends State<PlanCheckPage> {
  late GoogleMapController _controller;
  final List<Set<Marker>> markersList = [];
  List<Event> events = [];
  String planTitle = "";
  List<bool> showList = [];
  List<String> dateList = [];
  List<String> timeList = [];
  int eventCount = 100;

  AsyncMemoizer memory = AsyncMemoizer();

  _PlanCheckPageState() {
    for (int i = 0; i < eventCount; i++) {
      showList.add(false);
    }
  }
  listUpdate(){
    for (int i = eventCount; i < 100; i++) {
      showList.removeAt(eventCount);
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
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => listUpdate()); //빌드 후 실행
  }
  @override
  Widget build(BuildContext context) {
    memory.runOnce((){
      Plan plan =
      ModalRoute.of(context)!.settings.arguments as Plan;
      planTitle = plan.getTitle();
      events = plan.getEventList();
      dateList = plan.getDateList();
      timeList = plan.getTimeList();
      for (int i = 0; i < events.length; i++) {
        addMarker(LatLng(events[i].getLat(), events[i].getLng()));
      }
      eventCount = events.length;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(planTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              Navigator.popUntil(context, ModalRoute.withName('/toNavigationBarPage'));
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
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
                                onTap: () async{
                                  await events[index].getImage();
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
                                                    Text(dateList[index]),
                                                    SizedBox(width: 20,),
                                                    Text(timeList[index])
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
                                    Text("  공용", style: Theme.of(context).textTheme.headline2,),
                                    events[index].getCommonInfo()!=null
                                        ?Container(
                                      padding: EdgeInsets.only(left:10, right: 10),
                                      child: Text(events[index].getCommonInfo(), style: Theme.of(context).textTheme.bodyText1,),
                                    )
                                        :Container(),
                                    Text("  신체 장애", style: Theme.of(context).textTheme.headline2,),
                                    events[index].getDisabledInfo()!=null
                                        ?Container(
                                      padding: EdgeInsets.only(left:10, right: 10),
                                      child: Text(events[index].getDisabledInfo(), style: Theme.of(context).textTheme.bodyText1,),
                                    )
                                        :Container(),
                                    Text("  시각", style: Theme.of(context).textTheme.headline2,),
                                    events[index].getBlindInfo()!=null
                                        ?Container(
                                      padding: EdgeInsets.only(left:10, right: 10),
                                      child: Text(events[index].getBlindInfo(), style: Theme.of(context).textTheme.bodyText1,),
                                    )
                                        :Container(),
                                    Text("  청각", style: Theme.of(context).textTheme.headline2,),
                                    events[index].getDeafInfo()!=null
                                        ?Container(
                                      padding: EdgeInsets.only(left:10, right: 10),
                                      child: Text(events[index].getDeafInfo(), style: Theme.of(context).textTheme.bodyText1,),
                                    )
                                        :Container(),
                                    Text("  유아", style: Theme.of(context).textTheme.headline2,),
                                    events[index].getBabyInfo()!=null
                                        ?Container(
                                      padding: EdgeInsets.only(left:10, right: 10),
                                      child: Text(events[index].getBabyInfo(), style: Theme.of(context).textTheme.bodyText1,),
                                    )
                                        :Container(),
                                  ],
                                ),
                              )
                                  : Container()
                            ],
                          );
                        })),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
