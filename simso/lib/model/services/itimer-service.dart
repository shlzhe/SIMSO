import 'package:simso/model/entities/timer-model.dart';

abstract class ITimerService {
  Future<TimerModel> getTimer(String userID, int daysAgo);
  Future<TimerModel> createTimer(String userID);
  Future<bool> updateTimer(TimerModel timer);
}