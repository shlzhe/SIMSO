import 'package:simso/service-locator.dart';
import './view/login-page.dart';
import 'package:flutter/material.dart';

void main() {
  setupServiceLocator();
  runApp(SimsoApp());
}
class SimsoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }

}