import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class GetAPI extends StatefulWidget {
  const GetAPI({Key? key}) : super(key: key);

  @override
  State<GetAPI> createState() => _GetAPIState();
}

class _GetAPIState extends State<GetAPI> {

  fetchData() async {
    final db = FirebaseFirestore.instance;
    var url = 'https://apis.data.go.kr/B551011/KorWithService1/locationBasedList1?serviceKey=XN%2FesQfM49MU%2BbA5FbqGMUOT1CZfBskUfNYPs5G5Tr789RNHU7fAnq5OlwSz5AMwKvs5llHw45EY4whO5Fzxrw%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=AppTest&listYN=Y&arrange=A&mapX=126.9330781&mapY=37.5284304&radius=1000&_type=json';
    var response = await http.get(Uri.parse(url));
    var myJsonList, myJsonList2;

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      myJsonList = jsonData["response"]["body"]["items"]["item"];

      for (int i = 0; i < myJsonList.length; i++) {
        String contentId = await myJsonList[i]['contentid'];
        var response2 = await http.get(Uri.parse("https://apis.data.go.kr/B551011/KorWithService1/detailWithTour1?serviceKey=XN%2FesQfM49MU%2BbA5FbqGMUOT1CZfBskUfNYPs5G5Tr789RNHU7fAnq5OlwSz5AMwKvs5llHw45EY4whO5Fzxrw%3D%3D&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=AppTest&contentId=$contentId&_type=json"));

        var jsonData2 = jsonDecode(utf8.decode(response2.bodyBytes));
        myJsonList2 = jsonData2["response"]["body"]["items"]["item"][0];

        await db.collection('places').add({
          'title': myJsonList[i]['title'],
          'location': myJsonList[i]['addr1'],
          'lat': double.parse(myJsonList[i]['mapy']),
          'lng': double.parse(myJsonList[i]['mapx']),
          'like': rand(11).toDouble(),
          'image': myJsonList[i]['firstimage'],
          'category': int.parse(myJsonList[i]['contenttypeid']),

          // 공통
          'parking': myJsonList2['parking'],
          'publictransport': myJsonList2['publictransport'],
          'elevator': myJsonList2['elevator'],
          'restroom': myJsonList2['restroom'],
          'guidehuman': myJsonList2['guidehuman'],
          'handicapetc': myJsonList2['handicapetc'],

          // 신체
          'wheelchair': myJsonList2['wheelchair'],
          'auditorium': myJsonList2['auditorium'],
          'exit': myJsonList2['exit'],

          // 시각
          'braileblock': myJsonList2['braileblock'],
          'helpdog': myJsonList2['helpdog'],
          'audioguide': myJsonList2['audioguide'],
          'brailepromotion': myJsonList2['brailepromotion'],

          // 청각
          'hearingroom': myJsonList2['hearingroom'],

          // 유아
          'stroller' : myJsonList2['stroller'],
          'lactationroom' : myJsonList2['lactationroom'],
          'babysparechair' : myJsonList2['babysparechair'],
          'infantsfamilyetc' : myJsonList2['infantsfamilyetc'],

        }).then((documentSnapshot) async => await db.collection('places').doc(documentSnapshot.id).update({"placeId": documentSnapshot.id}));
      }
    } else {
      //만약 응답이 ok가 아니면 에러를 던집니다.
      throw Exception('불러오는데 실패했습니다');
    }
  }

  int rand(int num) {
    return Random().nextInt(num);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("get"),
          onPressed: () {
            fetchData();
          },
        ),
      ),
    );
  }
}
