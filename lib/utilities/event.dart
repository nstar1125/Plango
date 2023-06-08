
Map<String, dynamic> initEvent = {
  'title': "",
  'location': "",
  'lat': 0.0,
  'lng': 0.0,
  'placeId': "",
  'like': 0.0,

  'parking': "",
  'publictransport': "",
  'wheelchair': "",
  'exit': "",
  'elevator': "",
  'restroom': "",
  'auditorium': "",
  'handicapetc': "",
  'braileblock': "",
  'guidehuman': "",
  'helpdog': "",
  'brailepromotion': "",
};


class Event{
  String _title = "";
  String? _location = "";
  double _lat = 0.0;
  double _lng = 0.0;
  String _placeId = "";
  double _like = 0.0;

  String _parking = "";
  String _publictransport = "";
  String _wheelchair = "";
  String _exit = "";
  String _elevator = "";
  String _restroom = "";
  String _auditorium = "";
  String _handicapetc = "";
  String _braileblock = "";
  String _guidehuman = "";
  String _helpdog = "";
  String _brailepromotion = "";

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


  Map<String, dynamic> toMap() => {
    'title': _title,
    'location': _location,
    'lat': _lat,
    'lng': _lng,
    'placeId': _placeId,
    'like': _like,

    'parking': _parking,
    'publictransport': _publictransport,
    'wheelchair': _wheelchair,
    'exit': _exit,
    'elevator': _elevator,
    'restroom': _restroom,
    'auditorium': _auditorium,
    'handicapetc': _handicapetc,
    'braileblock': _braileblock,
    'guidehuman': _guidehuman,
    'helpdog': _helpdog,
    'brailepromotion': _brailepromotion,
  };

  Event.fromJson(Map<String, dynamic> json)
      :
        _title = json['title'],
        _location = json['location'],
        _lat = json['lat'],
        _lng = json['lng'],
        _placeId = json['placeId'],
        _like = json['like'],

        _parking = json['parking'],
        _publictransport = json['publictransport'],
        _wheelchair = json['wheelchair'],
        _exit = json['exit'],
        _elevator = json['elevator'],
        _restroom = json['restroom'],
        _auditorium = json['auditorium'],
        _handicapetc = json['handicapetc'],
        _braileblock = json['braileblock'],
        _guidehuman = json['guidehuman'],
        _helpdog = json['helpdog'],
        _brailepromotion = json['brailepromotion'];

}