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
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

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
      showSnackBar();
          state.stateChanged(() {
      state.changing = false;
    });
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

  void showSnackBar() {
    state.scaffoldKey.currentState.removeCurrentSnackBar();
    state.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          'Saved!',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
