import 'dart:async';
import 'package:simso/model/services/itimer-service.dart';
import './globals.dart' as globals;
import '../../service-locator.dart';


class TimerModel {
  // Constructor
  TimerModel({this.documentID, this.userID, this.day, this.timeOnAppSec});

  String documentID;
  String userID;
  String day;
  int timeOnAppSec;
  bool currentlyCounting;
  String get hours { 
    var hrInt = (this.timeOnAppSec / 3600).truncate(); 
    if (hrInt < 10)  
      return '0' + hrInt.toString();
    return hrInt.toString();
  }
  String get minutes { 
    var minInt = ((this.timeOnAppSec / 60) % 60).truncate(); 
    if (minInt < 10)  
      return '0' + minInt.toString();
    return minInt.toString();
  }
  String get seconds { 
    var secInt = (this.timeOnAppSec % 60).truncate(); 
    if (secInt < 10)  
      return '0' + secInt.toString();
    return secInt.toString();
  }

  // Service for updating timer
  ITimerService timerService = locator<ITimerService>();

  // Customer methods for this model
  startTimer() {
    this.currentlyCounting = true;
    var secs = Duration(seconds: 1);
    Timer.periodic(secs, (timer){
      if (!this.currentlyCounting)
        timer.cancel();
        else {
          this.timeOnAppSec += 1;
        }
      if (this.timeOnAppSec % 60 == 0) {
        if (this.timeOnAppSec >= (globals.limit.timeLimitMin * 60))
          globals.showAlert = true;
        else  
          this.timerService.updateTimer(this);
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