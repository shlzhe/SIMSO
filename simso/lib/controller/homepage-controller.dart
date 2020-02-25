import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/view/homepage.dart';
import '../view/add-music-page.dart';
import '../model/entities/globals.dart' as globals;

class HomepageController {
  HomepageState state;
  ITimerService _timerService;

  UserModel newUser = UserModel();
  String userID;

  HomepageController(this.state, this._timerService);

  Future addMusic() async {
    //SongModel s =
    await Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(state.user, null),
        ));
    // if (s != null) {
    //   state.songlist.add(s);
    // } else {

    // }
  }

  Future addMemes() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: null,
        ));
  }

  Future addThoughts() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: null,
        ));
  }

  Future addPhotos() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: null,
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
