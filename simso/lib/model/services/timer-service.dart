import 'dart:convert';

import 'package:http/http.dart';
import 'package:simso/model/entities/api-constants.dart';
import 'package:simso/model/entities/timer-model.dart';

import 'itimer-service.dart';

class TimerService extends ITimerService {
  String url = APIConstants.BaseAPIURL + '/timers';
  
  Future<TimerModel> getTimer(String userID, int daysAgo) async {
    var date = _encodeDate(_getDate(daysAgo));
    Response response = await get('$url?userID=$userID&day=$date');
    var jsonString = response.body;
    try {
      Map<String, dynamic> map = jsonDecode(jsonString);
      var id = map.keys.first;
      TimerModel timer = TimerModel.fromJson(map[id]);
      timer.docID = id;
      return timer;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> updateTimer(TimerModel timer) async {
    var encoded = json.encode(timer.toJson());
    Response response = await patch('$url?timerID=${timer.docID}', body: encoded);
    if (response.statusCode == 201) 
      return response.body;
    else
      return null;
  }

  @override
  Future<TimerModel> createTimer(String userID) async {
    var timer = new TimerModel();
    timer.timeOnAppSec = 0;
    timer.day = _getDate(0);
    timer.userID = userID;
    var encoded = json.encode(timer.toJson());
    Response response = await post(url, body: encoded);
    if (response.statusCode == 201){
      timer.docID = response.body;
      return timer;
    }
    else
      return null;
  }

  String _getDate(int daysAgo) {
    var today = DateTime.now();
    var ourDate = today.subtract(new Duration(days: daysAgo));
    var day = ourDate.day;
    var month = ourDate.month;
    var year = ourDate.year;
    return '$month/$day/$year';
  }

  String _encodeDate(String date) {
    return date.replaceAll('/', '%2F');
  }
}