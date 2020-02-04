import 'package:simso/model/entities/timer-model.dart';

abstract class ITimerService {
  Future<TimerModel> getTimer(String userID, DateTime day);
  Future<String> updateTimer(String timerID, int totalSeconds);
}