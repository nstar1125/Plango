import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  //스토리지 키 값
  static String _userLoggedInKey = "LOGGEDINKEY";
  static String _userNameKey = "USERNAMEKEY";
  static String _userEmailKey = "USEREMAILKEY";
  static String _userPwdKey = "USERPWDKEY";
  static String _userIDKey = "USERIDKEY";

  //스토리지 객체
  final _storage = new FlutterSecureStorage();

  ///////////////////////////////스토리지로 데이터 저장///////////////////////////////
  //로그인 상태 저장
  Future saveUserLoggedInStatus(String loggedInStatus) async {
    return await _storage.write(key: _userLoggedInKey, value: loggedInStatus);
  }

  //사용자 이름 저장
  Future saveUserName(String userName) async {
    return await _storage.write(key: _userNameKey, value: userName);
  }

  //이메일 저장
  Future saveUserEmail(String userEmail) async {
    return await _storage.write(key: _userEmailKey, value: userEmail);
  }

  //패스워드 저장
  Future saveUserPwd(String userPwd) async {
    return await _storage.write(key: _userPwdKey, value: userPwd);
  }

  //유저 파이어베이스 id 저장
  Future saveUserID(String userID) async {
    return await _storage.write(key: _userIDKey, value: userID);
  }

  ///////////////////////////스토리지로부터 데이터 받아오기///////////////////////////
  //로그인 상태 받아오기
  Future<String?> getUserLoggedInStatus() async {
    return _storage.read(key: _userLoggedInKey);
  }

  //사용자 이름 받아오기
  Future<String?> getUserName() async {
    return _storage.read(key: _userNameKey);
  }

  //이메일 받아오기
  Future<String?> getUserEmail() async {
    return _storage.read(key: _userEmailKey);
  }

  //패스워드 받아오기
  Future<String?> getUserPwd() async {
    return _storage.read(key: _userPwdKey);
  }

  //유저 파이어베이스 id 받아오기
  Future<String?> getUserID() async {
    return _storage.read(key: _userIDKey);
  }

  //스토리지 클리어
  Future deleteAll() async{
    return await _storage.deleteAll();
  }
}
