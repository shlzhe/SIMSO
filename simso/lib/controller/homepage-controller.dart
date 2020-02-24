import 'package:flutter/material.dart';

import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/homepage.dart';
import '../view/add-music-page.dart';
import '../model/entities/globals.dart' as globals;

class HomepageController {
  HomepageState state;
  ITimerService timerService;
  ITouchService touchService;
  UserModel newUser = UserModel();
  String userID;

  HomepageController(this.state, this.timerService, this.touchService);

  Future addMusic() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(),
        ));
  }

  Future addMemes() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(),
        ));
  }

  Future addThoughts() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(),
        ));
  }

  Future addPhotos() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(),
        ));
  }

  void setupTimer() async {
    if (globals.timer == null) {
      var timer = await timerService.getTimer(state.user.uid, 0);
      if (timer == null) {
        timer = await timerService.createTimer(state.user.uid);
      }

      globals.timer = timer;
      globals.timer.startTimer();
    }
  }

  void setupTouchCounter() async {
    if (globals.touchCounter == null) {
      var touchCounter = await touchService.getTouchCounter(state.user.uid, 0);
      if (touchCounter == null) {
        globals.touchCounter = await touchService.createTouchCounter(state.user.uid);
      }

      globals.touchCounter.addOne();

      globals.touchCounter = touchCounter;
    }
  }
}
