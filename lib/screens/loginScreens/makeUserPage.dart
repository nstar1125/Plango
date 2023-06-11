import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plango/utilities/firebaseService.dart';

class MakeUserPage extends StatefulWidget {
  const MakeUserPage({Key? key}) : super(key: key);

  @override
  State<MakeUserPage> createState() => _MakeUserPageState();
}

class _MakeUserPageState extends State<MakeUserPage> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _userName = ''; //유저 닉네임

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users"); //파이베이스 유저 컬렉션 가져오기

  bool _tryValidation() { //계정 생성 형식 확인
    final isValid = _formKey.currentState!.validate();
    if (isValid) { //형식이 맞으면,
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }
  void _showNameAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("닉네임 중복"),
          content: const Text("이미 존재하는 닉네임 입니다."),
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
    UserCredential _newUser = ModalRoute.of(context)!.settings.arguments as UserCredential; //argument 받아오기

    return Scaffold(
      appBar: AppBar( //앱 상단 바
        leading: IconButton(
          onPressed: () async{
            try{
              final currentUser = _authentication.currentUser;
              await currentUser?.delete();
              Navigator.pop(context);
            }catch(e){
              debugPrint("$e");
            }

          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("사용자 정보 입력"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Form(
                  key: _formKey,
                  child: TextFormField( //닉네임 입력창
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 3) {
                          return "닉네임은 최소 3글자 이상이야 합니다.";
                        }
                        return null;
                      }),
                      onSaved: ((value) {
                        _userName = value!;
                      }),
                      onChanged: (value) {
                        _userName = value;
                      },
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: "닉네임:",
                        ),
                      ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30)
              ),
              width: 150,
              child: CupertinoButton(
                child: Text("계정 생성하기",
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () async{
                  FocusScope.of(context).unfocus();
                  QuerySnapshot querySnapshot
                    = await userCollection.get();
                  List<Map<String, dynamic>> allUserData
                    = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                  if(_tryValidation()){ //닉네임 형식 확인
                    try{
                      for(int i=0; i<allUserData.length; i++){ //중복 닉네임 확인
                        if(allUserData[i]["fullName"] == _userName){
                          throw Error();
                        }
                      }
                      await FirebaseService(uid: _newUser.user!.uid) //유저 정보 파이어베이스 업로드
                          .savingUserData(
                        _newUser.user!.email!,
                        _userName
                      );
                      Navigator.pushNamedAndRemoveUntil(context, '/toInitialPage', (route) => false); //로그인
                      Navigator.pushNamed(context, '/toSignInPage');
                    }catch(e){
                      _showNameAlert();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
