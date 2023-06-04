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
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_uname),
              accountEmail: Text(_uemail),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              //teal
              title: const Text('설정'),
              onTap: () {},
              trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: const Icon(Icons.logout_sharp),
              title: const Text('로그아웃'),
              onTap: () async {
                await StorageService().deleteAll();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/toInitialPage', (route) => false); //로그인
              },
              trailing: const Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("home"),
      ),
    );
  }
}
