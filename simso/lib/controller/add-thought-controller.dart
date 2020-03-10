import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/song-model.dart';
import '../service-locator.dart';
import '../model/entities/user-model.dart';
import '../model/entities/thought-model.dart';
import '../model/services/ithought-service.dart';
import '../view/mydialog.dart';
import '../view/homepage.dart';
import '../view/add-thought-page.dart';
import '../view/my-thoughts-page.dart';

class AddThoughtController {
  AddThoughtPageState state;
  UserModel newUser = UserModel();
  String userID;
  IThoughtService _thoughtService = locator<IThoughtService>();
  List<SongModel> songlist;

  AddThoughtController(this.state);

  void getUserInfo() {
    print(state.user.username);
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
    if(!state.formKey.currentState.validate()){
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
      List<Thought> myThoughtsList = await _thoughtService.getThoughts(state.user.uid.toString());
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
