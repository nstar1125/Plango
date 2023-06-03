import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plango/utilities/firebaseService.dart';
import 'package:plango/utilities/storageService.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authentication = FirebaseAuth.instance;
  String? _userEmail = "";
  String? _userPassword = "";

  _getMyData() async {
    await StorageService().getUserEmail().then((value) {
      //내 아이디
      setState(() {
        _userEmail = value;
      });
    });
    await StorageService().getUserPwd().then((value) {
      //내 아이디
      setState(() {
        _userPassword = value;
      });
    });
  }

  _tryAutoLogin() async{
    Timer(const Duration(seconds: 2),()async{ //2초간 유지
      await _getMyData(); //내 정보 로컬로부터 받아오기
      try{
        if(_authentication.currentUser == null){
          debugPrint("null");
        }
        QuerySnapshot snapshot = await FirebaseService(
            uid: _authentication.currentUser!.uid)
            .getUserData(_userEmail!); //유저 데이터 이메일로 받이오기
        final newUser =
        await _authentication.signInWithEmailAndPassword(
            email: _userEmail!, password: _userPassword!); //파이어베이스 계정 확인
        if(newUser.user != null){
          Navigator.pushNamedAndRemoveUntil(context, '/toNavigationBarPage', (route) => false); //로그인
        }else{
          throw Error();
        }
      }catch(e){ //저장된 아이디 없는 경우
        debugPrint("저장된 아이디 없음");
        Navigator.pushReplacementNamed(context, "/toInitialPage"); //로그인 화면
      }
    }
    );
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _tryAutoLogin()); //빌드 후 실행
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("splash screen"),
      ),
    );
  }
}
