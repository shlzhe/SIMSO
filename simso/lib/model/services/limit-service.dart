import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/limit-model.dart';

import 'ilimit-service.dart';

class LimitService implements ILimitService {

  static const LIMIT_COLLECTION = 'limits';

  @override
  Future<LimitModel> createLimit(String userID) async {
    var limit = LimitModel(
      userID: userID, 
      lastUpdated: _getDate(0), 
      overrideThruDate: _getDate(1),
      timeLimitMin: 0,
      touchLimit: 0);
    await Firestore.instance.collection(LIMIT_COLLECTION)
      .add(limit.serialize())
      .then((docRef) {
        limit.documentID = docRef.documentID;
      })
      .catchError((onError) {
        print(onError);
        return null;
      });
      return limit;
  }

  @override
  Future<LimitModel> getLimit(String userID) async {
        try {
      var query = await Firestore.instance.collection(LIMIT_COLLECTION)
        .where(LimitModel.USER_ID, isEqualTo: userID)
        .getDocuments();

      if (query.documents.isEmpty)
        return null;
      else {
        return LimitModel.deserialize(query.documents.first.data, query.documents.first.documentID);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<bool> updateLimit(LimitModel limit) async {
    await Firestore.instance.collection(LIMIT_COLLECTION)
      .document(limit.documentID)
      .updateData(limit.serialize())
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