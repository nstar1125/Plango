import 'package:flutter/material.dart';
import 'package:plango/utilities/storageService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _uid = "";
  String _uname = "";
  String _uemail = "";

  final PageController pageController = PageController(
    initialPage: 0,
  );

  _getMyData() async {
    if (mounted) {
      try {
        await StorageService().getUserID().then((value) {
          //내 아이디
          setState(() {
            _uid = value!;
          });
        });
        await StorageService().getUserName().then((value) {
          //내 이름
          setState(() {
            _uname = value!;
          });
        });
        await StorageService().getUserEmail().then((value) {
          //내 그룹
          setState(() {
            _uemail = value!;
          });
        });
      } catch (NullPointException) {}
    }
  }
  @override
  void initState() {
    super.initState();
    _getMyData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        backgroundColor: Theme.of(context).accentColor,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              accountName: Text(_uname),
              accountEmail: Text(_uemail),
            ),
            ListTile(
              leading: Icon(Icons.settings,
                  color: Colors.white
              ),
              //teal
              title: Text('설정',
                style: Theme.of(context).textTheme.button,
              ),
              onTap: () {},
              trailing: Icon(Icons.navigate_next,
                  color: Colors.white
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout_sharp,
                  color: Colors.white
              ),
              title: Text('로그아웃',
                style: Theme.of(context).textTheme.button,
              ),
              onTap: () async {
                await StorageService().deleteAll();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/toInitialPage', (route) => false); //로그인
              },
              trailing: Icon(Icons.navigate_next,
                  color: Colors.white
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 340,
                child: PageView(
                  controller: pageController,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Image(
                          image: AssetImage(
                              "assets/images/home_illust_1.png"),
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Image(
                          image: AssetImage(
                              "assets/images/home_illust_2.png"),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width - 40,
                    color: Colors.grey),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "무장애 여행 일정을 만들어 보세요",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width - 40,
                    color: Colors.grey),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Image(
                    image: AssetImage(
                        "assets/images/hangang.png"),
                  )),
              SizedBox(height: 20),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "한강에서 피크닉을 즐겨보세요",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width - 40,
                    color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
