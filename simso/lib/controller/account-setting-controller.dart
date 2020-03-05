import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/entities/user-model.dart';
import '../view/mydialog.dart';
import '../view/account-setting-page.dart';
import '../service-locator.dart';
import 'package:simso/model/services/iuser-service.dart';

class AccountSettingController{
  AccountSettingPageState state;
  UserModel newUser = UserModel();
  String userID;
    IUserService userService = locator<IUserService>();

  AccountSettingController(this.state);

    void save() async {
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();

    try {
      if (state.user == null) {
        await userService.updateUserDB(state.user);
      }
           MyDialog.info(
          context: state.context,
          title: 'Firestore Save Error',
          message: 'Firestore is unavailable now. Try again later',
          action: () {
            Navigator.pop(state.context);
            Navigator.pop(state.context, null);
          });
      Navigator.pop(state.context, state.user);
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'Firestore Save Error',
          message: 'Firestore is unavailable now. Try again later',
          action: () {
            Navigator.pop(state.context);
            Navigator.pop(state.context, null);
          });
    }
  }

  // void getMyThoughtsList(String email) async {
  //   try {
  //      myThoughtsList = await _thoughtService.getThoughts(state.user.uid);
  //   } catch (e) {
  //      myThoughtsList = <Thought>[];
  //   }

  //   if(myThoughtsList == null || myThoughtsList.isEmpty){
  //     var newThought = Thought(tags: ['Welcome'],text: 'Welcome, add a new thought!', timestamp: DateTime.now(),uid: state.user.uid);
  //     myThoughtsList.add(newThought);
  //   }
  //   state.myThoughtsList = myThoughtsList;
    
  // }

    

}