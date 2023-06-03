import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton( //이메일로 로그인하기 버튼
                onPressed: () {
                  Navigator.pushNamed(context, "/toSignInPage");
                },
                child: Text("이메일로 로그인")),
            CupertinoButton( //이메일로 로그인하기 버튼
                onPressed: () {
                  Navigator.pushNamed(context, "/toSignUpPage");
                },
                child: Text("계정 생성하기")),
          ],
        ),
      ),
    );
  }
}
