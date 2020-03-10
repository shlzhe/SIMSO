import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../view/mydialog.dart';
import '../view/account-setting-page.dart';
import '../service-locator.dart';
import 'package:simso/model/services/iuser-service.dart';

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
