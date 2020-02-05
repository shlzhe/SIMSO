import 'package:flutter/material.dart';
import 'package:simso/model/services/itimer-service.dart';
import '../model/entities/globals.dart' as globals;
import '../service-locator.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key key, this.child}) : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}
class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  ITimerService _timerService = locator<ITimerService>();

  _LifeCycleManagerState() {
    _setupTimer();
  }

  _setupTimer() async {
    var timer = await _timerService.getTimer('k9tJ9uP4ZvNokxEfxSlm', 0);
    if (timer == null){
      timer = await _timerService.createTimer('k9tJ9uP4ZvNokxEfxSlm');
    }
    
    globals.timer = timer;
    globals.timer.startTimer();
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
        print('Resumed');
        globals.timer.startTimer();
        break;
      case AppLifecycleState.inactive:
        print('Inactive');
        globals.timer.stopTimer();
        break;
      case AppLifecycleState.paused:
        print('Paused');
        globals.timer.stopTimer();
        break;
      case AppLifecycleState.suspending:
        print('Suspended');
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