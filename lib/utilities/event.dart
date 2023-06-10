import 'dart:typed_data';

import 'package:http/http.dart' as http;

Map<String, dynamic> initEvent = {
  'title': "",
  'location': "",
  'lat': 0.0,
  'lng': 0.0,
  'placeId': "",
  'like': 0.0,
  'category': 0,

  'parking': "",
  'publictransport': "",
  'wheelchair': "",
  'exit': "",
  'elevator': "",
  'restroom': "",
  'auditorium': "",
  'handicapetc': "",
  'audioguide': "",
  'braileblock': "",
  'guidehuman': "",
  'helpdog': "",
  'brailepromotion': "",
  'hearingroom': "",
  'stroller': "",
  'lactationroom': "",
  'babysparechair': "",
  'infantsfamilyetc': "",
  'image': "",
  'imagedata': null,
};


class Event{
  String _title = "";
  String? _location = "";
  double _lat = 0.0;
  double _lng = 0.0;
  String _placeId = "";
  double _like = 0.0;
  int _category = 0;

  String _parking = "";
  String _publictransport = "";
  String _wheelchair = "";
  String _exit = "";
  String _elevator = "";

  String _restroom = "";
  String _auditorium = "";
  String _handicapetc = "";
  String _audioguide = "";
  String _braileblock = "";

  String _guidehuman = "";
  String _helpdog = "";
  String _brailepromotion = "";
  String _hearingroom = "";
  String _stroller = "";

  String _lactationroom = "";
  String _babysparechair = "";
  String _infantsfamilyetc = "";
  String _image = "";
  Uint8List? _imagedata;

  setTitle(String title){
    _title = title;
  }
  setLocation(String? location){
    _location = location;
  }
  setLatlng(double lat, double lng){
    _lat = lat;
    _lng = lng;
  }
  setPlaceId(String id){
    _placeId = id;
  }
  setLike(double like){
    _like = like;
  }
  addLike(){
    _like = _like + 1;
  }
  subLike(){
    if(_like > 0){
      _like = _like - 1;
    }
  }

  setCategory(int value) {
    _category = value;
  }

  setParking(String value) {
    _parking = value;
  }

  setPublictransport(String value) {
    _publictransport = value;
  }

  setWheelchair(String value) {
    _wheelchair = value;
  }

  setExit(String value) {
    _exit = value;
  }

  setElevator(String value) {
    _elevator = value;
  }

  setRestroom(String value) {
    _restroom = value;
  }

  setAuditorium(String value) {
    _auditorium = value;
  }

  setHandicapetc(String value) {
    _handicapetc = value;
  }

  setAudioguide(String value) {
    _audioguide = value;
  }

  setBraileblock(String value) {
    _braileblock = value;
  }

  setGuidehuman(String value) {
    _guidehuman = value;
  }

  setHelpdog(String value) {
    _helpdog = value;
  }

  setBrailepromotion(String value) {
    _brailepromotion = value;
  }

  setHearingroom(String value) {
    _hearingroom = value;
  }

  setStroller(String value) {
    _stroller = value;
  }

  setLactationroom(String value) {
    _lactationroom = value;
  }

  setBabysparechair(String value) {
    _babysparechair = value;
  }

  setInfantsfamilyetc(String value) {
    _infantsfamilyetc = value;
  }

  setImage(String value) {
    _image = value;
  }


  ////////////////////////////////////////////////////////////////////

  String getTitle(){
    return _title;
  }
  String? getLocation(){
    return _location;
  }
  double getLat(){
    return _lat;
  }
  double getLng(){
    return _lng;
  }
  String getPlaceId(){
    return _placeId;
  }
  double getLike(){
    return _like;
  }

  getImage() async{
    if (_image != "") {
      await http.get(Uri.parse(_image)).then((response) async {
        if (response.statusCode == 200) {
          // 이미지 데이터 받기
          _imagedata = response.bodyBytes;
        }
      }).catchError((error) {
      });
    }
  }
  getImageData() {
    return _imagedata;
  }

  String getCommonInfo(){
    String info = "";
    if (_parking != "") {
      info = info + "주차장: "+ _parking + '\n';
    }
    if (_publictransport != "") {
      info = info + "대중교통: "+_publictransport + '\n';
    }
    if (_elevator != "") {
      info = info + "엘리베이터: "+_elevator + '\n';
    }
    if (_restroom != "") {
      info = info + "화장실: "+ _restroom + '\n';
    }
    if (_handicapetc != "") {
      info = info + "장애시설: "+_handicapetc + '\n';
    }
    if (_guidehuman != "") {
      info = info + "안내요원: "+_guidehuman + '\n';
    }
    return info;
  }
  String getDisabledInfo(){
    String info = "";
    if (_wheelchair != "") {
      info = info + "휠체어: "+_wheelchair + '\n';
    }
    if (_auditorium != "") {
      info = info + "장애인석: "+_auditorium + '\n';
    }
    if (_exit != "") {
      info = info + "경사로: "+_exit + '\n';
    }
    return info;
  }
  String getBlindInfo(){
    String info = "";
    if (_braileblock != "") {
      info = info + "점자블록: "+ _braileblock + '\n';
    }
    if (_helpdog != "") {
      info = info + "안내견: "+_helpdog + '\n';
    }
    if (_brailepromotion != "") {
      info = info + "점자정보: "+_brailepromotion + '\n';
    }
    if (_audioguide != "") {
      info = info + "오디오 가이드: "+_audioguide + '\n';
    }
    return info;
  }
  String getDeafInfo(){
    String info = "";
    if (_hearingroom != "") {
      info = info + "청력실: "+_hearingroom + '\n';
    }
    return info;
  }
  String getBabyInfo(){
    String info = "";
    if (_stroller != "") {
      info = info + "유모차: "+ _stroller + '\n';
    }
    if (_lactationroom != "") {
      info = info + "수유실: "+_lactationroom + '\n';
    }
    if (_babysparechair != "") {
      info = info + "유아용 의자: "+_babysparechair + '\n';
    }
    if (_infantsfamilyetc != "") {
      info = info + "편의시설: "+_infantsfamilyetc + '\n';
    }
    return info;
  }

  String getCategory() {
    String str_category = "";

    if (_category == 12) {
      str_category = "관광지";
    }else if (_category == 14) {
      str_category = "문화시설";
    }else if (_category == 15) {
      str_category = "축제공연행사";
    }else if (_category == 25) {
      str_category = "여행코스";
    }else if (_category == 28) {
      str_category = "레포츠";
    }else if (_category == 32) {
      str_category = "숙박";
    }else if (_category == 38) {
      str_category = "쇼핑";
    }else if (_category == 39) {
      str_category = "음식점";
    }

    return str_category;
  }


  Map<String, dynamic> toMap() => {
    'title': _title,
    'location': _location,
    'lat': _lat,
    'lng': _lng,
    'placeId': _placeId,
    'like': _like,
    'category': _category,

    'parking': _parking,
    'publictransport': _publictransport,
    'wheelchair': _wheelchair,
    'exit': _exit,
    'elevator': _elevator,
    'restroom': _restroom,
    'auditorium': _auditorium,
    'handicapetc': _handicapetc,
    'audioguide' : _audioguide,
    'braileblock': _braileblock,
    'guidehuman': _guidehuman,
    'helpdog': _helpdog,
    'brailepromotion': _brailepromotion,
    'hearingroom': _hearingroom,
    'stroller': _stroller,
    'lactationroom': _lactationroom,
    'babysparechair': _babysparechair,
    'infantsfamilyetc': _infantsfamilyetc,
    'image': _image,
    'imagedata': _imagedata,
  };

  Event.fromJson(Map<String, dynamic> json)
      :
        _title = json['title'],
        _location = json['location'],
        _lat = json['lat'],
        _lng = json['lng'],
        _placeId = json['placeId'],
        _like = json['like'],
        _category = json['category'],

        _parking = json['parking'],
        _publictransport = json['publictransport'],
        _wheelchair = json['wheelchair'],
        _exit = json['exit'],
        _elevator = json['elevator'],
        _restroom = json['restroom'],
        _auditorium = json['auditorium'],
        _handicapetc = json['handicapetc'],
        _audioguide = json['audioguide'],
        _braileblock = json['braileblock'],
        _guidehuman = json['guidehuman'],
        _helpdog = json['helpdog'],
        _brailepromotion = json['brailepromotion'],
        _hearingroom = json['hearingroom'],
        _stroller = json['stroller'],
        _lactationroom = json['lactationroom'],
        _babysparechair = json['babysparechair'],
        _infantsfamilyetc = json['infantsfamilyetc'],
        _image = json['image'],
        _imagedata = json['imagedata']
  ;

}

class Plan{
  String? title;
  List<Event>? events;
  List<String>? dates;
  List<String>? times;
  Plan(String title, List<Event> events, List<String> dates, List<String> times){
    this.title = title;
    this.events = events;
    this.dates = dates;
    this.times = times;
  }
  String getTitle(){
    return this.title!;
  }
  List<Event> getEventList(){
    return this.events!;
  }
  List<String> getDateList(){
    return this.dates!;
  }
  List<String> getTimeList(){
    return this.times!;
  }

}