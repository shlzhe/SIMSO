import 'package:flutter/material.dart';
import 'package:simso/model/entities/timer-model.dart';
import '../model/entities/globals.dart' as globals;

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key key, this.child}) : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}
class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {

  _LifeCycleManagerState() {
    globals.timer = new TimerModel();
    globals.timer.startTimer();
    globals.timer.timeOnAppSec = 0;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        globals.timer.startTimer();
        break;
      case AppLifecycleState.inactive:
        globals.timer.stopTimer();
        break;
      case AppLifecycleState.paused:
        globals.timer.stopTimer();
        break;
      case AppLifecycleState.suspending:
        globals.timer.stopTimer();
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}