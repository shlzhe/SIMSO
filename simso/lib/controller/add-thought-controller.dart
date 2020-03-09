import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/song-model.dart';
import '../service-locator.dart';
import '../model/entities/user-model.dart';
import '../model/services/ithought-service.dart';
import '../view/mydialog.dart';
import '../view/homepage.dart';
import '../view/add-thought-page.dart';

class AddThoughtController {
  AddThoughtPageState state;
  UserModel newUser = UserModel();
  String userID;
  IThoughtService _thoughtService = locator<IThoughtService>();
  List<SongModel> songlist;

  AddThoughtController(this.state);

  void getUserInfo() {
    print("First");
    print(state.user.username);
    print("Last");
  }

/*
  void getUserName() async{
    state.user.uid = await _userService.getUserDataByID(userID);
    print(state.user);
    //return state.user.toString();
  }

*/
  String validateText(String value) {
    if (value == null || value.length == 0) {
      return 'Enter Text ';
    }
    return null;
  }

  void saveText(String value) {
    state.thoughtCopy.text = value;
  }

  void save() async {
    print('saving thought: ' + state.thoughtCopy.text);
    print('for ' + state.user.username);
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();
    state.thoughtCopy.uid = state.user.uid;
    state.thoughtCopy.timestamp = DateTime.now();

    try {
      if (state.thought == null) {
        //from add button
        state.thoughtCopy.documentID =
            await _thoughtService.addThought(state.thoughtCopy);
      } else {
        //for next sprint if not this one
        //await _thoughtService.updateThought(state.thoughtCopy);
      }
      state.thought = state.thoughtCopy;
      await Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => Homepage(state.user, songlist),
          ));
      Navigator.pop(state.context);
      //Navigator.pop(state.context, state.courseCopy);
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

  //keep void entry function below, I liked this snippet of code but can't remember why right now
  /*
    void entry(String newValue) {
      print("entry(" + newValue + ") called.");
    if (newValue!=null){
      state.entry = true;
    }
    if (newValue=='') state.entry = false;
    state.stateChanged((){});
  }
  */

}
