import 'package:flutter/material.dart';
import 'package:simso/controller/time-management-controller.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/model/services/ilimit-service.dart';
import '../model/entities/globals.dart' as globals;

import '../service-locator.dart';
import 'design-constants.dart';

class TimeManagementPage extends StatefulWidget {
  final UserModel user;

  TimeManagementPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return TimeManagementPageState(user);
  }
}

class TimeManagementPageState extends State<TimeManagementPage> {
  UserModel user;
  TimeManagementController controller;
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  ILimitService limitService = locator<ILimitService>();

  TimeManagementPageState(this.user) {
    controller = TimeManagementController(this, timerService, touchService, this.limitService);
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Management'),
        backgroundColor: DesignConstants.blueLight,
      ),
      backgroundColor: DesignConstants.blue,
      body: Container(
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 75),
                  child: Text(
                'Time Spent Today',
                style: TextStyle(fontSize: 24, color: Colors.white),
              )),
            ),
            Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${globals.timer.hours}',
                      style: TextStyle(fontSize: 60, color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
                      child: Text(
                        'hr',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '${globals.timer.minutes}',
                      style: TextStyle(fontSize: 60, color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
                      child: Text(
                        'm',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '${globals.timer.seconds}',
                      style: TextStyle(fontSize: 60, color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, left: 4, right: 4),
                      child: Text(
                        's',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )),  
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 50),
                  child: Text(
                'Touches Today',
                style: TextStyle(fontSize: 24, color: Colors.white),
              )),
            ),            
            Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[                    
                    Text(
                      '${globals.touchCounter.touches}',
                      style: TextStyle(fontSize: 64, color: Colors.white),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 65, right: 65, top: 50),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                color: DesignConstants.blueLight,
                child: Text('Review Week', style: TextStyle(color: Colors.white, fontSize: 18),),
                onPressed: controller.reviewWeek,
              ),),
            Container(
              margin: EdgeInsets.only(left: 65, right: 65, top: 10),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                color: DesignConstants.yellow,
                child: Text('Set Limits', style: TextStyle(color: Colors.black, fontSize: 18),),
                onPressed: controller.setLimits,
              ),),
          ],
        ),
      ),
    );
  }
}
