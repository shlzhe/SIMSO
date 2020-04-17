import 'package:flutter/cupertino.dart';
import '../model/entities/globals.dart' as globals;

class CallRequestPage extends StatefulWidget {
  @override
  _CallRequestPageState createState() => _CallRequestPageState();
}

class _CallRequestPageState extends State<CallRequestPage> {
  @override
  void dispose() {
    globals.callState = false;
    globals.c = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Call request"),
      ),
    );
  }
}
