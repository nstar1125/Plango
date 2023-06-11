import 'package:geolocator/geolocator.dart';
import 'package:plango/utilities/event.dart';

class AutoPath{
  late List<Event> eventPool; //탐색할 이벤트의 집합
  late Event startE;
  late List<String> bias;

  AutoPath(List<Event> eList, List<String> bias){  //생성자
    eventPool = eList;
    this.bias = bias;
    startE = getFirstE();
  }

  makePath(int count){  //start event를 기준으로 count만큼 일정이 포함된 event list를 리턴하는 함수
    List<Event> path = [startE];  //path에 시작 이벤트를 포함한다.
    print("********** add first **********");
    print(startE.getTitle());
    print("*******************************");
    print("");
    for(int i = 0; i<count-1; i++){ //카운트만큼 반복하여 다음 이벤트를 path에 추가한다.
      Event nextE= getNextE(path[path.length-1]);  //뒤 이벤트 확인
      if(path[path.length-1] != nextE){
        print("********** add behind **********");
        print(nextE.getTitle());
        print("*******************************");
        print("");
        path.add(nextE);
      }else{
        break;
      }
    }
    return path;
  }
  getFirstE(){
    double maxPt = 0;
    int maxIdx = 0;
    for(int i = 0; i<eventPool.length; i++){  //모든 이벤트 반복해서
      print("from : "+eventPool[i].getTitle());
      print("to : "+eventPool[i].getTitle());
      double tempPt = getLinkPt(eventPool[i], eventPool[i]);
      if (maxPt<tempPt){
        maxPt = tempPt;
        maxIdx = i;
      }
    }
    Event firstE = eventPool[maxIdx];
    print("--------------->");
    print(eventPool.length);
    eventPool.removeAt(maxIdx);
    print(eventPool.length);
    print(">---------------");
    print("");
    return firstE;
  }
  getNextE(Event curEvent){
    double maxPt = 0;
    int maxIdx = -1;
    for(int i = 0; i<eventPool.length; i++){  //모든 이벤트 반복해서
      double tempPt = 0;
      if(eventPool[i]!=curEvent){
        print("from : "+curEvent.getTitle());
        print("to : "+eventPool[i].getTitle());
        tempPt = getLinkPt(curEvent, eventPool[i]); //Start event로부터 각 event까지 링크의 점수를 계산
      }
      if (maxPt<tempPt){
        maxPt = tempPt;
        maxIdx = i;
      }
    }
    Event nextE;
    if(maxIdx == -1){
      print("<<<no events>>>");
      print("");
      nextE = curEvent;
    }else{
      nextE = eventPool[maxIdx];
      print("--------------->");
      print(eventPool.length);
      eventPool.removeAt(maxIdx);
      print(eventPool.length);
      print(">---------------");
      print("");
    }
    return nextE;
  }
  getLinkPt(Event s_node, Event e_node){ // 두 이벤트간 링크 점수를 계산하는 함수
    double distance;
    double liked = e_node.getLike();
    double total = 0;
    if (s_node != e_node){
      distance =
          Geolocator.distanceBetween(s_node.getLat(),s_node.getLng(),e_node.getLat(),e_node.getLng());  //s_node와 e_node간 거리 점수
    }else{
      distance = 0;
    }
    var pref;

    pref = getBiasPt(e_node.getCategory(), this.bias)*10;
    total = (1000-distance)/100 + liked + pref.toDouble();

    print("distance : "+((1000-distance)/100).toString());
    print("liked : "+(liked).toString());
    print("pref : "+(pref).toString());
    print("TOTAL : "+total.toString());
    print("");

    return total;
  }
  int getBiasPt(String check_type, List<String> bias){
    if(bias.contains(check_type))
      return 1;
    else
      return 0;
  }
}