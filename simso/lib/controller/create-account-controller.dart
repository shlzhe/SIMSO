import 'package:flutter/material.dart';
import 'package:simso/controller/firebase.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/create-account.dart';
import 'package:simso/view/mydialog.dart';

class CreateAccountController{
  CreateAccountState state;
  CreateAccountController(this.state);

  String validateEmail(String value) {
    if (!(value.contains('@') || value.contains('.')) || value.contains(' ')){
      return '  Invalid email format. \n  Must contain @ and . \n  Also no empty spaces.';
    }
    return null;
  }

  void saveEmail(String newValue) {
    state.user.email = newValue;
  }

  String validatePassword(String value) {
    if (value.length < 5){
      return '  Please enter at least 5 characters.';
    }
    return null;
  }

  void savePassword(String newValue) {
    state.user.password = newValue;
  }

  void saveUsername(String newValue) {
    state.user.username = newValue;
  }

  void saveAboutMe(String newValue) {
    state.user.aboutme = newValue;
  }

  void saveCity(String newValue) {
    state.user.city = newValue;
  }

  void saveRelationship(String newValue) {
    state.user.relationship = newValue;
  }

  void saveMemo(String newValue) {
    state.user.memo = newValue;
  }

  void saveFavorite(String newValue) {
    state.user.favorites = newValue;
  }

  void createAccount() async {
    if(!state.formKey.currentState.validate()){
      return;
    }
    state.formKey.currentState.save();
    MyDialog.showProgressBar(state.context);
    try{
      state.user.uid = await FirebaseFunctions.createAccount(state.user.email, state.user.password);
      if (state.user.uid!=''||state.user.uid!=null){
        FirebaseFunctions.createProfile(state.user);
      }
    }
    catch(error){
       MyDialog.popProgressBar(state.context);
      MyDialog.info(
        
        context: state.context,
        title: 'Account Creation Error',
        message: error.message != null ? error.message: error.toString(),
        action: () => Navigator.pop(state.context),
      );
        return;  //Do not proceed if log in failed
    }
    MyDialog.popProgressBar(state.context);
      state.user = UserModel.isEmpty();
      createCancel();
  }

  void createCancel() {
    Navigator.pop(state.context);
  }
}