import 'package:flutter/material.dart';
import 'package:simso/model/entities/limit-model.dart';
import 'package:simso/model/entities/timer-model.dart';
import 'package:simso/model/entities/touch-counter-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/add-limits-page.dart';
import 'package:simso/view/time-management-page.dart';
import 'package:simso/view/usage-graph-page.dart';
import '../model/entities/globals.dart' as globals;

class TimeManagementController {
  TimeManagementPageState state;
  ITimerService timerService;
  ITouchService touchService;
  ILimitService limitService;

  TimeManagementController(this.state, this.timerService, this.touchService, this.limitService);

  void reviewWeek() async {
    var timers = List<TimerModel>();
    var touchCounters = List<TouchCounterModel>();
    for (var i = 6; i >= 0; i--) {
      var timer = await this.timerService.getTimer(state.user.uid, i);
      if (timer == null) {
        var date = timerService.getDate(i);
        timer = TimerModel(day: date, timeOnAppSec: 0, userID: state.user.uid);
      }
      timers.add(timer);

      var touchCounter = await this.touchService.getTouchCounter(state.user.uid, i);
      if (touchCounter == null) {
        var date = timerService.getDate(i);
        touchCounter = TouchCounterModel(day: date, touches: 0, userID: state.user.uid);
      }
      touchCounters.add(touchCounter);
    }

    Navigator.push(state.context,
        MaterialPageRoute(builder: (context) => UsageGraphPage(state.user, timers, touchCounters)));
  }

  void setLimits() async {
    var limit = new LimitModel.deserialize(globals.limit.serialize(), globals.limit.documentID);
    
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => AddLimitsPage(state.user, limit)
    ));
  }
}