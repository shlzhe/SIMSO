import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/song-model.dart';
import '../service-locator.dart';
import '../model/entities/thought-model.dart';
import '../model/services/ithought-service.dart';
import '../view/mydialog.dart';
import '../view/add-thought-page.dart';
import '../view/my-thoughts-page.dart';

class AddThoughtController {
  AddThoughtPageState state;
  IThoughtService _thoughtService = locator<IThoughtService>();
  List<SongModel> songlist;

  AddThoughtController(this.state);

  String validateText(String value) {
    if (value == null || value.length == 0) {
      return 'Enter Text ';
    }
    return null;
  }

  void saveText(String value) {
    state.thought.text = value;
    state.thought.email = state.user.email;
  }

  void save() async {
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();
    state.thought.uid = state.user.uid;
    state.thought.timestamp = DateTime.now();    

    try {
        await _thoughtService.addThought(state.thought);
      
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
