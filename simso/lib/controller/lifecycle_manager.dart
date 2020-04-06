import 'package:flutter/material.dart';
import '../model/entities/globals.dart' as globals;

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key key, this.child}) : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}
class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {

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
        if (globals.touchCounter != null) 
          globals.touchCounter.addOne();
        if (globals.timer != null)
          globals.timer.startTimer();
        break;
      case AppLifecycleState.inactive:
        print('Inactive');
        if (globals.timer != null)
          globals.timer.stopTimer();
        break;
      case AppLifecycleState.paused:
        print('paused');
        if (globals.timer != null)
          globals.timer.stopTimer();
        break;
      case AppLifecycleState.detached:
        print('detatched');
        if (globals.timer != null)
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