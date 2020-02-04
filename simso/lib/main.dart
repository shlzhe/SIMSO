import 'package:simso/service-locator.dart';
import './view/login-page.dart';
import 'package:flutter/material.dart';

import 'controller/lifecycle_manager.dart';

void main() {
  setupServiceLocator();
  runApp(SimsoApp());
}
class SimsoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: MaterialApp(
        home: LoginPage(),
      )
    );
  }

}