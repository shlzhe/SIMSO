import 'dart:async';

class TimerModel {
  TimerModel({this.docID, this.userID, this.day, this.timeOnAppSec});

  String docID;
  String userID;
  DateTime day;
  int timeOnAppSec;
  bool currentlyCounting;

  startTimer() {
    print('Timer started');
    this.currentlyCounting = true;
    var secs = Duration(seconds: 1);
    Timer.periodic(secs, (timer){
      if (!this.currentlyCounting)
        timer.cancel();
        else {
          print('Timer incrimented'); 
          this.timeOnAppSec++;
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

  Map<String, dynamic> toJson() {
    return {
      'userID' : userID,
      'day' : day,
      'timeOnAppSec' : timeOnAppSec,
    };
  }
}