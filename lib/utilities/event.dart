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

  String getInfo(){
    String info = "";
    if (_parking != "") {
      info = info + _parking + '\n';
    }
    if (_publictransport != "") {
      info = info + _publictransport + '\n';
    }
    if (_wheelchair != "") {
      info = info + _wheelchair + '\n';
    }
    if (_exit != "") {
      info = info + _exit + '\n';
    }
    if (_elevator != "") {
      info = info + _elevator + '\n';
    }
    if (_restroom != "") {
      info = info + _restroom + '\n';
    }
    if (_auditorium != "") {
      info = info + _auditorium + '\n';
    }
    if (_handicapetc != "") {
      info = info + _handicapetc + '\n';
    }
    if (_braileblock != "") {
      info = info + _braileblock + '\n';
    }
    if (_guidehuman != "") {
      info = info + _guidehuman + '\n';
    }
    if (_helpdog != "") {
      info = info + _helpdog + '\n';
    }
    if (_brailepromotion != "") {
      info = info + _brailepromotion + '\n';
    }
    if (_audioguide != "") {
      info = info + _audioguide + '\n';
    }
    if (_hearingroom != "") {
      info = info + _hearingroom + '\n';
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
        _image = json['image'],
        _imagedata = json['imagedata']
  ;

}