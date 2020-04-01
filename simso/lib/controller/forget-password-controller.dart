import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/view/forget-password.dart';

class ForgetPasswordController{
  ForgetPasswordState state;
  IUserService userService;
  ForgetPasswordController(this.state, this.userService);

  String validateEmail(String value) {
    if (!value.contains('@') || !value.contains('.'))
      return 'Invalid email format';
    else return null;
  }

  void saveEmail(String newValue) {
    state.email = newValue;
  }

  void checkEmail()async {
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();
    FirebaseAuth.instance.sendPasswordResetEmail(email: state.email);
    Navigator.pop(state.context);
  }

  void answerQuestions() async{
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();
    state.questions = await userService.readQuestion();
    state.answers = await userService.answerQuestion(state.email);
    state.displayQuestions = true;
    state.q1 = Random().nextInt(5);
    state.q2 = Random().nextInt(5);
    while (state.q2==state.q1) {
      state.q2 = Random().nextInt(5);
    }
    state.formKey.currentState.reset();
    state.stateChanged((){});
  }

  void resetWithQA() {
    String msg = ' is your new temporary password! Please Change your password in Account Settings!';
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();
    if (state.answers[state.q1]==state.a1 && state.answers[state.q2]==state.a2) 
      {
        state.password = Random().nextInt(9).toString() + Random().nextInt(9).toString() + Random().nextInt(9).toString()+
        Random().nextInt(9).toString() + Random().nextInt(9).toString() + Random().nextInt(9).toString();
        state.msg = state.password + msg;
        }
    else state.password = 'Password reset has been rejected!';
    
    print(state.password);
    state.stateChanged((){});

  }

  void saveA2(String newValue) {
    state.a2 = newValue;
  }

  void saveA1(String newValue) {
    state.a1 = newValue;
  }
}