import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/touch-counter-model.dart';

import 'itouch-service.dart';

class TouchService extends ITouchService {
  // Keep collection here
  static const TOUCH_COUNTER_COLLECTION = 'touchCounter';

  @override
  Future<TouchCounterModel> createTouchCounter(String userID) async {
    var date = _getDate(0);
    var touchCounter = TouchCounterModel(day: date, touches: 0, userID: userID);
    await Firestore.instance.collection(TOUCH_COUNTER_COLLECTION)
      .add(touchCounter.serialize())
      .then((docRef) {
        touchCounter.documentID = docRef.documentID;
      })
      .catchError((onError) {
        print(onError);
        return null;
      });
      return touchCounter;
  }

  @override
  Future<TouchCounterModel> getTouchCounter(String userID, int daysAgo) async {
    try {
      var query = await Firestore.instance.collection(TOUCH_COUNTER_COLLECTION)
        .where(TouchCounterModel.USER_ID, isEqualTo: userID)
        .where(TouchCounterModel.DAY, isEqualTo: _getDate(daysAgo))
        .getDocuments();

      if (query.documents.isEmpty)
        return null;
      else {
        return TouchCounterModel.deserialize(query.documents.first.data, query.documents.first.documentID);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> updateTouchCounter(TouchCounterModel touchCounter) async {
    await Firestore.instance.collection(TOUCH_COUNTER_COLLECTION)
      .document(touchCounter.documentID)
      .updateData(touchCounter.serialize())
      .catchError((onError) {
        print(onError);
        return false;
      });
      return true;
  }

  // Custom, non-Firebase methond
  String _getDate(int daysAgo) {
    var today = DateTime.now();
    var ourDate = today.subtract(new Duration(days: daysAgo));
    var day = ourDate.day;
    var month = ourDate.month;
    var year = ourDate.year;
    return '$month/$day/$year';
  }
}