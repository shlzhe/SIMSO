import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/entities/user-model.dart';
import '../view/mydialog.dart';
import '../view/account-setting-page.dart';
import '../service-locator.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:simso/model/entities/user-model.dart';
import '../service-locator.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../view/homepage.dart';

class AccountSettingController {
  AccountSettingPageState state;
  IUserService userService = locator<IUserService>();
  AccountSettingController(this.state);

  void saveUserName(String value) {
    state.userCopy.username = value;
  }

  void saveGender(String value) {
    state.userCopy.gender = value;
  }

  void saveAge(int value) {
    state.userCopy.age = value;
  }

  void saveAboutMe(String value) {
    state.userCopy.aboutme = value;
  }

  void saveEmail(String value) {
    state.userCopy.email = value;
  }

  void savePassword(String value) {
    state.userCopy.password = value;
  }

  void save() async {
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();

    try {
      await userService.updateUserDB(state.userCopy);

      Navigator.pop(state.context, state.userCopy);
      
            await Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => Homepage(state.user),
          ));
          Navigator.pop(state.context); 
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
}
