import 'package:flutter/material.dart';
import 'package:simso/controller/login-page-controller.dart';
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  BuildContext _context;
  LoginPageController _controller;

  LoginPageState() {
    _controller = LoginPageController(this);
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
      ),
    );
  }
}
