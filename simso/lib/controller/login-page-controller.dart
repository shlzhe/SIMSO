
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/login-page.dart';

class LoginPageController{
  
  LoginPageState state;

  LoginPageController(this.state);


  String validateEmail(String value) {
    return null;
  }

  void saveEmail(String newValue) {
  }

  void goToHomepage() {
    Navigator.push(state.context,MaterialPageRoute(
    builder: (context) => Homepage(state.user),
  ));
  }
}