
Map<String, dynamic> initEvent = {
  'title': "",
  'location': "",
  'lat': 0.0,
  'lng': 0.0,
  'placeId': "",
  'like': 0.0,
};


class Event{
  String _title = "";
  String? _location = "";
  double _lat = 0.0;
  double _lng = 0.0;
  String _placeId = "";
  double _like = 0.0;
  // like, isBooked, count


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
  };

  Event.fromJson(Map<String, dynamic> json)
      :
        _title = json['title'],
        _location = json['location'],
        _lat = json['lat'],
        _lng = json['lng'],
        _placeId = json['placeId'],
        _like = json['like'];

}