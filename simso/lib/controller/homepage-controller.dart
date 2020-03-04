import 'package:camera/new/camera.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/add-photo-page.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/mainChat-page.dart';
import '../view/add-music-page.dart';
import '../view/add-thought-page.dart';
import '../model/entities/globals.dart' as globals;

class HomepageController {
  HomepageState state;
  ITimerService timerService;
  ITouchService touchService;
  UserModel newUser = UserModel();
  List<UserModel>userList;
  String userID;

  HomepageController(this.state, this.timerService, this.touchService);

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

  Future addThought() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddThoughtPage(state.user),
        ));
  }

  Future addPhotos() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddPhoto(state.user, null),
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
        touchCounter = await touchService.createTouchCounter(state.user.uid);
      }

      globals.touchCounter = touchCounter;
      globals.touchCounter.addOne();
    }
  }

  void mainChatScreen() async {
    print('mainChatPage() called');
    //Retrieve all SimSo users
    try{
      userList  = await MyFirebase.getUsers(); 
    }catch(e){
      throw e.toString();
    }
    //Navigate MainChatScreen Page
    //Passing the userList array to MainChatScreen Page
     Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => MainChatPage(state.user,userList),
        ));
  }
}
