import 'package:simso/model/entities/local-user.dart';
import 'package:simso/service-locator.dart';
import './view/login-page.dart';
import 'package:flutter/material.dart';

import 'controller/lifecycle_manager.dart';

void main() {
  setupServiceLocator();
  runApp(SimsoApp());
}
class SimsoApp extends StatelessWidget {
  SimsoApp();
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: MaterialApp(
        home: LoginPage(localUserFunction: LocalUser(),),
      )
    );
  }

}