
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/firebase.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/login-page.dart';
import 'package:simso/view/mydialog.dart';

class LoginPageController{
  
  LoginPageState state;

  LoginPageController(this.state);

  void goToHomepage() async{
    if(!state.formKey.currentState.validate()){
      return;
    }
    state.formKey.currentState.save();
    MyDialog.showProgressBar(state.context);
    try{
      state.user.uid = await FirebaseFunctions.login(state.user.email, state.user.password);
      }
    catch(error){
       MyDialog.popProgressBar(state.context);
      MyDialog.info(
        
        context: state.context,
        title: 'Login Error',
        message: error.message != null ? error.message: error.toString(),
        action: () => Navigator.pop(state.context),
      );
        return;  //Do not proceed if log in failed
    }
    if (state.user.uid!=null|| state.user.uid !=''){
      Navigator.push(state.context,MaterialPageRoute(
      builder: (context) => Homepage(state.user),
      ));
    }
    else return null;
    //need to send message of success or failure. need to create a load in progress indicator.
  }

  String validateEmail(String value) {
    if (!(value.contains('@') || value.contains('.'))){
      return 'Invalid email format entered. Must contain @ and .';
    }
    return null;
  }

  void saveEmail(String newValue) {
    state.user.email = newValue;
  }

  String validatePassword(String value) {
    if (value.length < 5){
      return 'Please enter at least 5 characters.';
    }
    return null;
  }

  void savePassword(String newValue) {
    state.user.password = newValue;
  }
}