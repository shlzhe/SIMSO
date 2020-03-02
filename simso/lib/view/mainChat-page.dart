import 'package:flutter/material.dart';
import 'package:simso/controller/homepage-controller.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/model/services/iuser-service.dart';

import '../service-locator.dart';

class MainChatPage extends StatefulWidget {
  final UserModel user;

 MainChatPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return MainChatPageState (user);
  }
}

class MainChatPageState extends State<MainChatPage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  MainChatPageController controller;
  UserModel user;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  MainChatPageState(this.user) {
    controller = MainChatPage(this, this.timerService, this.touchService);
    controller.setupTimer();
    controller.setupTouchCounter();
  }

  void stateChanged(Function f) {
    setState(f);
  }
  @override
  Widget build(BuildContext context) {
  
    return null;
  }
}
  
