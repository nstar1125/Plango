import 'package:flutter/material.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({Key? key}) : super(key: key);

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
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
    "축제행사",
    "여행코스",
    "레저스포츠",
    "숙박",
    "쇼핑",
    "음식점",
  ];

  List<Image> sel_type_image = [];
  List<String> sel_pref_string = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: Text("일정 성격"),
      ),
      backgroundColor: Colors.white,
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
                onPressed: () {},
                icon: Icon(Icons.settings_sharp),
                label: Text("일정 자동 생성"),
            )
          ],
        ),
      ),
    );
  }
}
