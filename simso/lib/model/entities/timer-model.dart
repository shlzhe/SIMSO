import 'dart:async';
import 'package:simso/model/services/itimer-service.dart';

import '../../service-locator.dart';


class TimerModel {
  // Constructor
  TimerModel({this.documentID, this.userID, this.day, this.timeOnAppSec});

  String documentID;
  String userID;
  String day;
  int timeOnAppSec;
  bool currentlyCounting;

  // Service for updating timer
  ITimerService _timerService = locator<ITimerService>();

  // Customer methods for this model
  startTimer() {
    this.currentlyCounting = true;
    var secs = Duration(seconds: 10);
    Timer.periodic(secs, (timer){
      if (!this.currentlyCounting)
        timer.cancel();
        else {
          this.timeOnAppSec += 10;
        }
      if (this.timeOnAppSec % 60 == 0) {
        this._timerService.updateTimer(this);
      }
    });  
  }

  stopTimer() {
    this.currentlyCounting = false;
  }

  // Map from Firebase to object
  TimerModel.deserialize(Map<String, dynamic> map, String docID) :
    documentID = docID,
    userID = map[USER_ID],
    day = map[DAY],
    timeOnAppSec = map[TME_ON_APP_SEC];

  // From object to map for Firebase  
  Map<String, dynamic> serialize() => 
  {
    USER_ID: userID,
    DAY: day,
    TME_ON_APP_SEC: timeOnAppSec
  };

  // Fields
  static const USER_ID = 'userID';
  static const DAY = 'day';
  static const TME_ON_APP_SEC = 'timeOnAppSec';
}