import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plango/utilities/event.dart';

class SearchPlanPage extends StatefulWidget {
  const SearchPlanPage({Key? key}) : super(key: key);

  @override
  State<SearchPlanPage> createState() => _SearchPlanPageState();
}

class _SearchPlanPageState extends State<SearchPlanPage> {
  final db = FirebaseFirestore.instance;
  CollectionReference planCollection = FirebaseFirestore.instance.collection('plans');
  final currentUser = FirebaseAuth.instance;

  String _typedTitle = "";

  List<Event> selectedEvents = [];

  //이름 유사성 확인
  bool _checkSimilarName(String search, String typed) {
    //입력 값이 찾는 값보다 많으면 다름
    if (typed.length > search.length) return false;
    //입력 값이 0이면 다름
    if (typed.length == 0) {
      return false;
    }
    //유사도 확인
    for (int i = 0; i < typed.length; i++) {
      if (typed[i] != search[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text("일정 검색"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:20, right:20, bottom: 20),
                child: Form(
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 16
                    ),
                    onTap: () {
                      setState(() {
                      });
                    },
                    onChanged: (value) async {
                      setState(() {
                        _typedTitle = value;
                      });
                    },
                    onSaved: (value) async {
                      setState(() {
                        _typedTitle = value!;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: planCollection.snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if(streamSnapshot.hasData){
                        return ListView.builder(
                          //검색리스트 보이기
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                            if (_checkSimilarName(documentSnapshot["title"], _typedTitle)) {
                              return GestureDetector(
                                onTap: () async{
                                  for (int i = 0; i < documentSnapshot['eventList'].length; i++){
                                    String eventId = documentSnapshot['eventList'][i];
                                    final eventData = await db.collection("places").doc(eventId).get();

                                    Event tempEvent = Event.fromJson(initEvent);

                                    tempEvent.setTitle(eventData.data()!["title"]);
                                    tempEvent.setLocation(eventData.data()!["location"]);
                                    tempEvent.setLatlng(eventData.data()!["lat"],eventData.data()!["lng"]);
                                    tempEvent.setPlaceId(eventData.data()!["location"]);
                                    tempEvent.setLike(eventData.data()!["like"]);
                                    tempEvent.setCategory(eventData.data()!["category"]);

                                    tempEvent.setParking(eventData.data()!["parking"]);
                                    tempEvent.setPublictransport(eventData.data()!["publictransport"]);
                                    tempEvent.setWheelchair(eventData.data()!["wheelchair"]);
                                    tempEvent.setExit(eventData.data()!["exit"]);
                                    tempEvent.setElevator(eventData.data()!["elevator"]);

                                    tempEvent.setRestroom(eventData.data()!["restroom"]);
                                    tempEvent.setAuditorium(eventData.data()!["auditorium"]);
                                    tempEvent.setHandicapetc(eventData.data()!["handicapetc"]);
                                    tempEvent.setAudioguide(eventData.data()!["audioguide"]);
                                    tempEvent.setBraileblock(eventData.data()!["braileblock"]);

                                    tempEvent.setGuidehuman(eventData.data()!["guidehuman"]);
                                    tempEvent.setHelpdog(eventData.data()!["helpdog"]);
                                    tempEvent.setBrailepromotion(eventData.data()!["brailepromotion"]);
                                    tempEvent.setHearingroom(eventData.data()!["hearingroom"]);
                                    tempEvent.setStroller(eventData.data()!["stroller"]);

                                    tempEvent.setLactationroom(eventData.data()!["lactationroom"]);
                                    tempEvent.setBabysparechair(eventData.data()!["babysparechair"]);
                                    tempEvent.setInfantsfamilyetc(eventData.data()!["infantsfamilyetc"]);
                                    tempEvent.setImage(eventData.data()!["image"]);

                                    selectedEvents.add(tempEvent);

                                  }
                                  List<String> dates = [];
                                  List<String> times = [];
                                  for(int i = 0; i<documentSnapshot['dateList'].length; i++){
                                    dates.add(documentSnapshot['dateList'][i]);
                                  }
                                  for(int i = 0; i<documentSnapshot['timeList'].length; i++){
                                    times.add(documentSnapshot['timeList'][i]);
                                  }
                                  Plan selectedPlan
                                  = new Plan(documentSnapshot['title'],selectedEvents,dates,times);

                                  Navigator.of(context).pushNamed('/toPlanCheckPage', arguments: selectedPlan);
                                  selectedEvents = [];
                                  //초기화
                                },
                                child: Card(
                                  margin: EdgeInsets.all(10.0),
                                  child: ListTile(
                                    title: Text(
                                      documentSnapshot['title'],
                                    ),
                                    subtitle: Text(
                                      documentSnapshot['dateList'][0],
                                    ),
                                    trailing: Text(
                                      documentSnapshot['plannerName'],
                                    ),
                                  ),
                                ),
                              );
                            }
                            else{
                              return Container();
                            }
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
