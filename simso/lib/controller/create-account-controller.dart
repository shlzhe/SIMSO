import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/view/choose-avatar.dart';
import 'package:simso/view/create-account.dart';
import 'package:simso/view/mydialog.dart';

class CreateAccountController{
  CreateAccountState state;
  IUserService userService;
  CreateAccountController(this.state, this.userService);

  String validateEmail(String value) {
    if (!(value.contains('@') || value.contains('.'))){
      return '  Invalid email format. \n  Must contain @ and . \n  Also no empty spaces.';
    }
    return null;
  }

  void saveEmail(String newValue) {
    newValue = newValue.replaceAll(' ', '');
    state.user.email = newValue.replaceAll(String.fromCharCode(newValue.length-1), '');
  }

  String validatePassword(String value) {
    if (value.length <= 5){
      return '  Please enter at least 6 characters.';
    }
    return null;
  }

  void savePassword(String newValue) {
    state.user.password = newValue;
  }

  void saveUsername(String newValue) {
    state.user.username = newValue;
  }

  void createAccount() async {
    if(!state.formKey.currentState.validate()){
      return;
    }
    state.formKey.currentState.save();
    MyDialog.showProgressBar(state.context);
    try{
      state.user.uid = await userService.createAccount(state.user);
      if (state.user.uid!=''||state.user.uid!=null){
        userService.createUserDB(state.user);
      }
    }
    catch(error){
       MyDialog.popProgressBar(state.context);
      MyDialog.info(
        
        context: state.context,
        title: 'Account Creation Error',
        message: 'Invalid data entered. \n Please enter data with the correct formatting',
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

  void avatarPicture() async {
    state.user.profilePic = await Navigator.push(state.context, MaterialPageRoute(
      builder: (context)=>ChooseAvatar()));
  }
}