import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/song-model.dart';
import '../service-locator.dart';
import '../model/entities/user-model.dart';
import '../model/entities/thought-model.dart';
import '../model/entities/dictionary-word-model.dart';
import '../model/services/ithought-service.dart';
import '../view/mydialog.dart';
import '../view/homepage.dart';
import '../view/edit-thought-page.dart';
import '../view/my-thoughts-page.dart';
import '../view/profile-page.dart';

class EditThoughtController {
  EditThoughtPageState state;
  UserModel newUser;
  Thought thought;
  String userID;
  IThoughtService _thoughtService = locator<IThoughtService>();

  EditThoughtController(this.state);

  String validateText(String value) {
    if (value == null || value.length == 0) {
      return 'Enter Text ';
    }
    return null;
  }

  void saveText(String value) {
    state.thoughtCopy.text = value;
  }

  void deleteThought() async {
    print('deleting thought docid' + state.thought.thoughtId);
    try {
      _thoughtService.deleteThought(state.thought.thoughtId);

      List<Thought> myThoughtsList =
          await _thoughtService.getThoughts(state.user.uid.toString());
      await Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => MyThoughtsPage(state.user, myThoughtsList),
          ));
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'Firestore Save Error',
          message: 'Firestore is unavailable now. Try adding thought later.',
          action: () {
            Navigator.pop(state.context);
            Navigator.pop(state.context, null);
          });
    }
  }

  void save() async {
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();

    try {
      await _thoughtService.updateThought(state.thoughtCopy);

      state.thought = state.thoughtCopy;

      //prep to exit page
      List<Thought> myThoughtsList =
          await _thoughtService.getThoughts(state.user.uid.toString());
      await Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => MyThoughtsPage(state.user, myThoughtsList),
          ));
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'Firestore Save Error',
          message: 'Firestore is unavailable now. Try adding thought later.',
          action: () {
            Navigator.pop(state.context);
            Navigator.pop(state.context, null);
          });
    }
  }
}
