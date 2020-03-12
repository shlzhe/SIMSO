import 'package:flutter/material.dart';
import '../view/profile-page.dart';
import '../view/account-setting-page.dart';

class ProfilePageController {
  ProfilePageState state;
  ProfilePageController(this.state);

  
  void accountSettings() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AccountSettingPage(state.user),
        ));
  }
}