import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plango/utilities/event.dart';

class MyPlanListPage extends StatefulWidget {
  const MyPlanListPage({Key? key}) : super(key: key);

  @override
  State<MyPlanListPage> createState() => _MyPlanListPageState();
}

class _MyPlanListPageState extends State<MyPlanListPage> {
  final db = FirebaseFirestore.instance;
  CollectionReference planCollection = FirebaseFirestore.instance.collection('plans');
  final currentUser = FirebaseAuth.instance;

  List<Event> selectedEvents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("나의 일정"),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: planCollection.where('plannerId', isEqualTo: currentUser.currentUser!.uid).snapshots(),  //where함수 이용해서 파이어베이스의 document를 필터링 할 수 있음, 로그인한 아이디의 event만 볼 수 있도록 설정
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if(streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                return Dismissible(
                  key: Key(streamSnapshot.data!.docs.toString()),
                  background: Card(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.red,
                    child: Center(
                      child: ListTile(
                        trailing: Icon(Icons.delete),
                      ),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction){
                    DocumentReference planDoc = planCollection.doc(documentSnapshot.id);
                    planDoc.delete();
                  },
                  child: GestureDetector(
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
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
