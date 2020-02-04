import 'package:simso/model/entities/timer-model.dart';

import 'itimer-service.dart';

class TimerService extends ITimerService {
  Future<TimerModel> getTimer(String userID, DateTime day) {
    throw Exception('Method not yet implimented');
  }

  @override
  Future<String> updateTimer(String timerID, int totalSeconds) {
    throw Exception('Method not yet implimented');
  }
}