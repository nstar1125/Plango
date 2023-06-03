import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{
  final String? uid; //자신의 id (user id)

  FirebaseService({this.uid}); //argument로 받아오기

  final CollectionReference _userCollection =
  FirebaseFirestore.instance.collection("users"); //유저 컬렉션

  //유저 정보 데이터 저장
  Future savingUserData(String email, String fullName) async {
    final DocumentReference userDocument = _userCollection.doc(uid);
    return await userDocument.set({
      "id": uid,
      "email": email,
      "fullName": fullName,
    });
  }

  //유저 데이터 받아오기
  Future getUserData(String email) async {
    //이메일로 유저컬렉션에서 해당 유저 찾음(로그인시 사용)
    QuerySnapshot snapshot =
    await _userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

}
