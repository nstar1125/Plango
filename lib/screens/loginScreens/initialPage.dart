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
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30)
              ),
              width: 200,
              child: CupertinoButton( //이메일로 로그인하기 버튼
                  onPressed: () {
                    Navigator.pushNamed(context, "/toSignInPage");
                  },
                  child: Text("이메일로 로그인",style: Theme.of(context).textTheme.button)),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(30)
              ),
              width: 200,
              child: CupertinoButton( //이메일로 로그인하기 버튼
                  onPressed: () {
                    Navigator.pushNamed(context, "/toSignUpPage");
                  },
                  child: Text("계정 생성하기",style: Theme.of(context).textTheme.button)),
            ),
          ],
        ),
      ),
    );
  }
}
