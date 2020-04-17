import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:simso/controller/usage-graph-controller.dart';
import 'package:simso/model/entities/timer-model.dart';
import 'package:simso/model/entities/touch-counter-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'design-constants.dart';
import '../model/entities/globals.dart' as globals;

class UsageGraphPage extends StatefulWidget {
  final UserModel user;
  final List<TimerModel> timers;
  final List<TouchCounterModel> touchCounters;

  UsageGraphPage(this.user, this.timers, this.touchCounters);

  @override
  State<StatefulWidget> createState() {
    return UsageGraphPageState(user, timers, touchCounters);
  }
}

class UsageGraphPageState extends State<UsageGraphPage> {
  UserModel user;
  List<TimerModel> timers;
  List<TouchCounterModel> touchCounters;
  List<charts.Series<TimerModel, String>> timerSeries;
  Padding timerChart;
  Padding touchChart;

  UsageGraphController controller;

  UsageGraphPageState(this.user, this.timers, this.touchCounters) {
    controller = UsageGraphController(this);
    timerChart = controller.getTimerChart;
    touchChart = controller.getTouchChart;
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    globals.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('This Week\'s Usage'),
        backgroundColor: DesignConstants.blueLight,
      ),
      backgroundColor: DesignConstants.blue,
      body: Container(
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    'Minutes',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  )),
            ),
            timerChart,
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    'Touches',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  )),
            ),
            touchChart,
          ],
        ),
      ),
    );
  }
}
