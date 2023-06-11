import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:plango/utilities/autoPath.dart';
import 'package:plango/utilities/event.dart';
import 'package:geolocator/geolocator.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({Key? key}) : super(key: key);

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  final db = FirebaseFirestore.instance;

  int _count = 1;
  List<Image> disable_type_image = [
    Image.asset('assets/images/disabled.png'),
    Image.asset('assets/images/body.png'),
    Image.asset('assets/images/blind.png'),
    Image.asset('assets/images/deaf.png'),
    Image.asset('assets/images/baby.png'),
  ];
  List<Image> pref_image = [
    Image.asset('assets/images/pref_site.png'),
    Image.asset('assets/images/pref_movie.png'),
    Image.asset('assets/images/pref_concert.png'),
    Image.asset('assets/images/pref_tour.png'),
    Image.asset('assets/images/pref_sport.png'),
    Image.asset('assets/images/pref_hotel.png'),
    Image.asset('assets/images/pref_shopping.png'),
    Image.asset('assets/images/pref_restaurant.png'),
  ];
  List<String> pref_string = [
    "관광지",
    "문화시설",
    "축제공연행사",
    "여행코스",
    "레포츠",
    "숙박",
    "쇼핑",
    "음식점",
  ];

  List<Image> sel_type_image = [];
  List<int> sel_type_int = [];

  List<String> sel_pref_string = [];

  List<Event> events = [];
  List<Event> eventPool = [];
  late PlaceDetails locDetail;

  _buildDisableChoiceList() {
    List<Widget> choices = [];
    disable_type_image.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
        child: ChoiceChip(
          selectedColor: Theme.of(context).primaryColor,
          label: Container(width: 35, height: 50, child: item),
          selected: sel_type_image.contains(item),
          onSelected: (selected) {
            setState(() {
              sel_type_image.contains(item)
                  ? sel_type_image.remove(item)
                  : sel_type_image.add(item);

              int temp_index = disable_type_image.indexOf(item);
              !sel_type_image.contains(item)
                  ? sel_type_int.remove(temp_index)
                  : sel_type_int.add(temp_index);
            });
          },
        ),
      ));
    });
    return choices;
  }

  _buildPrefChoiceList() {
    List<Widget> choices = [];
    pref_string.forEach((item) {
      choices.add(Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              width: 160,
              height: 109,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  width: 1,
                  color: Colors.grey
                )
              ),
              child: pref_image[pref_string.indexOf(item)],
            ),
            ChoiceChip(
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              label: Text(item, style: Theme.of(context).textTheme.button),
              selected: sel_pref_string.contains(item),
              onSelected: (selected) {
                setState(() {
                  sel_pref_string.contains(item)
                      ? sel_pref_string.remove(item)
                      : sel_pref_string.add(item);
                });
              },
            ),
          ],
        ),
      ));
    });
    return choices;
  }

  getEventPool() async{
    //// event pool 생성 시작
    QuerySnapshot querySnapshot = await db.collection("places").get();
    List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    if(allData.isNotEmpty) {
      for(int i = 0; i < allData.length; i++) {

        double distanceInMeters = Geolocator.distanceBetween(locDetail.geometry!.location.lat, locDetail.geometry!.location.lng,
            allData[i]["lat"], allData[i]["lng"]);

        if(distanceInMeters < 1000){
          Event tempEvent = Event.fromJson(initEvent);

          tempEvent.setTitle(allData[i]['title']);
          tempEvent.setLocation(allData[i]['location']);
          tempEvent.setLatlng(allData[i]['lat'],allData[i]['lng']);
          tempEvent.setPlaceId(allData[i]['placeId']);
          tempEvent.setLike(allData[i]['like']);
          tempEvent.setCategory(allData[i]['category']);

          tempEvent.setParking(allData[i]['parking']);
          tempEvent.setPublictransport(allData[i]['publictransport']);
          tempEvent.setWheelchair(allData[i]['wheelchair']);
          tempEvent.setExit(allData[i]['exit']);
          tempEvent.setElevator(allData[i]['elevator']);

          tempEvent.setRestroom(allData[i]['restroom']);
          tempEvent.setAuditorium(allData[i]['auditorium']);
          tempEvent.setHandicapetc(allData[i]['handicapetc']);
          tempEvent.setAudioguide(allData[i]['audioguide']);
          tempEvent.setBraileblock(allData[i]['braileblock']);

          tempEvent.setGuidehuman(allData[i]['guidehuman']);
          tempEvent.setHelpdog(allData[i]['helpdog']);
          tempEvent.setBrailepromotion(allData[i]['brailepromotion']);
          tempEvent.setHearingroom(allData[i]['hearingroom']);
          tempEvent.setStroller(allData[i]['stroller']);

          tempEvent.setLactationroom(allData[i]['lactationroom']);
          tempEvent.setBabysparechair(allData[i]['babysparechair']);
          tempEvent.setInfantsfamilyetc(allData[i]['infantsfamilyetc']);
          tempEvent.setImage(allData[i]['image']);

          eventPool.add(tempEvent);


        }
      }
    }
    //// 1km 내의 event pool 생성 끝
    // event pool test
  }
  showAlertMsg(){
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("생성된 일정이 없습니다. 다른 지역을 선택해주세요."),
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
  bool hasCommonElement(List<int> list1, List<int> list2) {
    for (var element in list1) {
      if (list2.contains(element)) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    getEventPool();
  }

  @override
  Widget build(BuildContext context) {
    locDetail = ModalRoute.of(context)!.settings.arguments as PlaceDetails;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Text("일정 성격"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(Icons.man),
              Text(" 장애 유형", style: Theme.of(context).textTheme.headline2),
            ]),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Wrap(children: _buildDisableChoiceList()),
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(Icons.check),
              Text(" 여행 취향", style: Theme.of(context).textTheme.headline2),
            ]),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Center(child: Wrap(children: _buildPrefChoiceList())),
            ),
            SizedBox(height: 20),
            Row(
                //시간
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.library_add),
                  Text(" 최대 일정 수", style: Theme.of(context).textTheme.headline2)
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _count = _count - 1;
                        if (_count < 1) _count = 1;
                      });
                    },
                    icon: Icon(Icons.remove_circle,
                        color: Theme.of(context).accentColor)),
                Container(
                  color: Colors.white,
                  height: 20,
                  width: 200,
                  child: Center(
                    child: Text("${_count}"),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _count = _count + 1;
                        if (_count > 6) _count = 6;
                      });
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).accentColor,
                    ))
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
                onPressed: () async{
                  List<Event> tempEventList = [];
                  for(int i = 0; i<eventPool.length; i++){
                    if(hasCommonElement(eventPool[i].getSelType(), sel_type_int)){
                      tempEventList.add(eventPool[i]);
                    }
                  }
                  print(tempEventList.length);
                  if(tempEventList.length>0){
                    print("Pool : "+(tempEventList.length).toString());
                    print(sel_pref_string);
                    AutoPath auto = new AutoPath(tempEventList, sel_pref_string);
                    events = await auto.makePath(_count);
                    await Navigator.of(context).pushNamed('/toShowAutoPathPage', arguments: events).then((e){
                      eventPool= [];
                      getEventPool();
                      print("Pool end : "+(eventPool.length).toString());
                      events.clear();
                    });
                  }else{
                    showAlertMsg();
                  }
                  events.clear();
                },
                icon: Icon(Icons.settings_sharp),
                label: Text("일정 자동 생성"),
            )
          ],
        ),
      ),
    );
  }
}
