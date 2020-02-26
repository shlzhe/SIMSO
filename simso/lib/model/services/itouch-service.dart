import 'package:simso/model/entities/touch-counter-model.dart';

abstract class ITouchService {
  Future<TouchCounterModel> getTouchCounter(String userID, int daysAgo);
  Future<TouchCounterModel> createTouchCounter(String userID);
  Future<bool> updateTouchCounter(TouchCounterModel touchCounter);
}