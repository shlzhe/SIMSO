import 'package:flutter/material.dart';

import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/view/homepage.dart';
import '../view/add-music-page.dart';
import '../view/add-photo-page.dart';
import '../model/entities/globals.dart' as globals;

class HomepageController {
  HomepageState state;
  ITimerService _timerService;
  UserModel newUser = UserModel();
  String userID;

  HomepageController(this.state, this._timerService);

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
          builder: (context) => AddPhoto(),
        ));
  }

  void setupTimer() async {
    var timer = await _timerService.getTimer(state.user.uid, 0);
    if (timer == null) {
      timer = await _timerService.createTimer(state.user.uid);
    }

    globals.timer = timer;
    globals.timer.startTimer();
  }
}
