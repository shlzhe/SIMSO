import 'package:simso/model/entities/timer-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'itimer-service.dart';

class TimerService extends ITimerService {
  // Keep collection here
  static const TIMERS_COLLECTION = 'timers';
  
  // Simple get
  Future<TimerModel> getTimer(String userID, int daysAgo) async {
    try {
      var query = await Firestore.instance.collection(TIMERS_COLLECTION)
        .where(TimerModel.USER_ID, isEqualTo: userID)
        .where(TimerModel.DAY, isEqualTo: getDate(daysAgo))
        .getDocuments();

      if (query.documents.isEmpty)
        return null;
      else {
        return TimerModel.deserialize(query.documents.first.data, query.documents.first.documentID);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Update
  @override
  Future<bool> updateTimer(TimerModel timer) async {
    await Firestore.instance.collection(TIMERS_COLLECTION)
      .document(timer.documentID)
      .updateData(timer.serialize())
      .catchError((onError) {
        print(onError);
        return false;
      });
      return true;
  }

  // Create 
  @override
  Future<TimerModel> createTimer(String userID) async {
    var date = getDate(0);
    var timer = TimerModel(day: date, timeOnAppSec: 0, userID: userID);
    await Firestore.instance.collection(TIMERS_COLLECTION)
      .add(timer.serialize())
      .then((docRef) {
        timer.documentID = docRef.documentID;
      })
      .catchError((onError) {
        print(onError);
        return null;
      });
      return timer;
  }

  @override
  String getDate(int daysAgo) {
    var today = DateTime.now();
    var ourDate = today.subtract(new Duration(days: daysAgo));
    var day = ourDate.day;
    var month = ourDate.month;
    var year = ourDate.year;
    return '$month/$day/$year';
  }
}