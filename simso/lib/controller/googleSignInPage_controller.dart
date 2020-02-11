import 'package:flutter/material.dart';
import 'package:simso/controller/firebase.dart';

import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/view/googleSignInPage.dart';
import 'package:simso/view/mydialog.dart';
import '../view/add-music-page.dart';
import '../model/entities/globals.dart' as globals;

class GoogleSignInPageController {
  GoogleSignInPageState state;
  
  String userID;

  GoogleSignInPageController(this.state);


  String validateEmail(String value) {
    if (!(value.contains('@') || value.contains('.')) || value.contains(' ')){
      return '  Invalid email format. \n  Must contain @ and . \n  Also no empty spaces.';
    }
    return null;
  }

  void saveEmail(String newValue) {
    state.stateChanged((){
       state.user.gmail = newValue;
    });
   
  }

  String validatePassword(String value) {
    if (value.length < 5){
      return '  Please enter at least 5 characters.';
    }
    return null;
  }

  void savePassword(String newValue) {
    state.user.gPassword = newValue;
  }



  void googleSignIn() async{
    print('google Sign In called in Google Sign In Page');
    print('gmail input:   ${state.user.gmail}');
    print('gpassword input:   ${state.user.gPassword}');
    /*
    if(!state.formKey.currentState.validate()){
      return;
    }
    state.formKey.currentState.save();
    print(state.user.email);
    MyDialog.showProgressBar(state.context);
    try{
      state.user.uid = await FirebaseFunctions.login(state.user.email, state.user.password);
      if (state.user.uid!=''||state.user.uid!=null){
        state.user = await FirebaseFunctions.readUser(state.user.uid);
        state.stateChanged((){});
      }
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
      MyDialog.popProgressBar(state.context);
      Navigator.push(state.context,MaterialPageRoute(
      builder: (context) => GoogleSignInPage(state.user),
      ));
    }
    else return null;
    //need to send message of success or failure. need to create a load in progress indicator.
*/
  }

}
