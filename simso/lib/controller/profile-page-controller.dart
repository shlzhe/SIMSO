import 'package:flutter/material.dart';
import 'package:simso/view/my-thoughts-page.dart';
import 'package:simso/view/visit-thoughts-page.dart';
import '../view/profile-page.dart';
import '../view/account-setting-page.dart';
import '../model/entities/thought-model.dart';
import '../model/services/ithought-service.dart';
import '../service-locator.dart';

class ProfilePageController {
  ProfilePageState state;
  ProfilePageController(this.state);
  IThoughtService _thoughtService = locator<IThoughtService>();

  void accountSettings() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
            builder: (context) => AccountSettingPage(
                  state.currentUser,
                )));
  }

  void thoughtsPage() async {
    List<Thought> thoughtsList = [];

    if (state.currentUser.uid == state.visitUser.uid) {
      //user wants to visit their own thoughts
      try {
        thoughtsList = await _thoughtService.getThoughts(state.currentUser.uid);
      } catch (e) {
        print(e);
      }
    } else {
      //user wants to visit another person's thoughts
      try {
        thoughtsList = await _thoughtService.getThoughts(state.visitUser.uid);
            Navigator.push(
        state.context,
        MaterialPageRoute(
            builder: (context) =>
                MyThoughtsPage(state.currentUser, thoughtsList)));
        for (Thought thought in thoughtsList) {
          thought.text = await _thoughtService.translateThought(
              state.currentUser.language, thought.text);
        }

            Navigator.push(
        state.context,
        MaterialPageRoute(
            builder: (context) =>
                VisitThoughtsPage(thoughtsList)));
      } catch (e) {
        print(e);
      }
    }


  }
}
