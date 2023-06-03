import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plango/utilities/firebaseService.dart';
import 'package:plango/utilities/storageService.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String _userEmail = ''; //유저 이메일 정보
  String _userPassword = ''; //유저 패스워드 정보

  bool _tryValidation() { //로그인 형식 확인
    final isValid = _formKey.currentState!.validate();
    if (isValid) { //형식이 맞으면,
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }
  void _showLoginAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: const Text("로그인 실패"),
          content: const Text("존재하지 않는 이메일이나 잘못된 \n패스워드입니다."),
          actions: [
            CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( //키보드 숨기기
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar( // 앱 상단 바
          title: const Text("이메일 로그인"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormField( //이메일 텍스트필드
                    validator: ((value) {
                      if (value!.isEmpty || !value.contains('@')) { //이메일 형식이 유효하지 않다면,
                        return "유효한 이메일 형식을 입력하세요.";
                      }
                      return null;
                    }),
                    onSaved: ((value) {
                      _userEmail = value!;
                    }),
                    onChanged: (value) {
                      _userEmail = value;
                    },
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "이메일",
                        ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  TextFormField( //패스워드 텍스트필드
                    obscureText: true,
                    validator: ((value) {
                      if (value!.isEmpty) { //패스워드가 비어 있으면,
                        return "패스워드를 입력하세요.";
                      }
                      return null;
                    }),
                    onSaved: ((value) {
                      _userPassword = value!;
                    }),
                    onChanged: (value) {
                      _userPassword = value;
                    },
                    decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "패스워드",
                        ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 40),
                  CupertinoButton( //로그인 버튼
                    child: Text("로그인"),
                    onPressed: () async{
                      FocusScope.of(context).unfocus();
                      if(_tryValidation()){ //로그인 형식 확인
                        try{
                          if(FirebaseAuth.instance.currentUser == null){
                            debugPrint("null");
                          }
                          final newUser =
                          await _authentication.signInWithEmailAndPassword(
                              email: _userEmail, password: _userPassword); //파이어베이스 계정 확인
                          QuerySnapshot snapshot = await FirebaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                              .getUserData(_userEmail); //유저 데이터 이메일로 받이오기
                          if(newUser.user != null){
                            await StorageService().saveUserLoggedInStatus("true"); //스토리지에 로그인 정보 저장
                            await StorageService().saveUserName(snapshot.docs[0]['fullName']); //스토리지에 닉네임 저장
                            await StorageService().saveUserEmail(_userEmail); //스토리지에 이메일 저장
                            await StorageService().saveUserPwd(_userPassword);
                            await StorageService().saveUserID(snapshot.docs[0]['id']); //스토리지에 파이어베이스 id 저장
                            Navigator.pushNamedAndRemoveUntil(context, '/toNavigationBarPage', (route) => false); //로그인
                          }
                        }catch(e){ //에러 메시지
                          debugPrint("$e");
                          _showLoginAlert();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
