import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';

import 'package:simso/view/main-screen-page.dart';


class MainScreenPageController{
  MainScreenPageState state;
  ITimerService timerService;
  ITouchService touchService;
  UserModel newUser = UserModel();
  String userID;

  MainScreenPageController(this.state);

 


}
