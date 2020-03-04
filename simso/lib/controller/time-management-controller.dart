import 'package:flutter/material.dart';
import 'package:simso/model/entities/limit-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import 'package:simso/view/add-limits-page.dart';
import 'package:simso/view/time-management-page.dart';
import '../model/entities/globals.dart' as globals;

class TimeManagementController {
  TimeManagementPageState state;
  ILimitService limitService;
  TimeManagementController(this.state, this.limitService);

  void reviewWeek() {
  }

  void setLimits() async {
    var limit = new LimitModel.deserialize(globals.limit.serialize(), globals.limit.documentID);
    
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => AddLimitsPage(state.user, limit)
    ));
  }
}