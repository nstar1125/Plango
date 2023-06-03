import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plango/screens/createPlanScreens/mapPage.dart';
import 'package:plango/screens/homeScreens/homePage.dart';
import 'package:plango/screens/myPlanScreens/myPlanPage.dart';
import 'package:plango/screens/otherPlanScreens/otherPlanPage.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({Key? key}) : super(key: key);

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _selectedIndex = 0; //선택한 페이지 번호

  //네비게이션할 페이지 리스트
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MapPage(),
    const MyPlanPage(),
    const OtherPlanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)), //선택 페이지
      bottomNavigationBar: BottomNavigationBar( //네비게이션 바
        currentIndex: _selectedIndex,
        onTap: (int i){ //네비게이션 바에서 페이지 선택
          setState((){
            _selectedIndex = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "홈"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.pen), label: "일정 작성"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.list_bullet), label: "나의 일정"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: "일정 검색"),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
