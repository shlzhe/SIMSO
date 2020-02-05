import 'dart:async';
import 'package:simso/model/services/itimer-service.dart';

import '../../service-locator.dart';


class TimerModel {
  TimerModel({this.docID, this.userID, this.day, this.timeOnAppSec});

  String docID;
  String userID;
  String day;
  int timeOnAppSec;
  bool currentlyCounting;

  bool newTimer;
  ITimerService _timerService = locator<ITimerService>();

  startTimer() {
    print('Timer started');
    this.currentlyCounting = true;
    var secs = Duration(seconds: 10);
    Timer.periodic(secs, (timer){
      if (!this.currentlyCounting)
        timer.cancel();
        else {
          print('Timer incrimented'); 
          this.timeOnAppSec += 10;
        }
      if (this.timeOnAppSec % 60 == 0) {
        print('uploadingChanges');
        this._timerService.updateTimer(this);
      }
    });  
  }

  stopTimer() {
    print('Timer stopped');
    this.currentlyCounting = false;
  }

  TimerModel.fromJson(Map<String, dynamic> json): 
    userID = json['userID'],
    day = json['day'],
    timeOnAppSec = json['timeOnAppSec'];

  Map<String, dynamic> toJson() => 
  {
    'userID': userID,
    'day': day,
    'timeOnAppSec': timeOnAppSec
  };
}