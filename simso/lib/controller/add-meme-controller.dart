import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/song-model.dart';
import '../service-locator.dart';
import '../model/entities/user-model.dart';
import '../model/entities/meme-model.dart';
import '../model/entities/dictionary-word-model.dart';
import '../model/services/imeme-service.dart';
import '../view/mydialog.dart';
import '../view/homepage.dart';
import '../view/add-meme-page.dart';
import '../view/my-memes-page.dart';

class AddMemeController {
  AddMemePageState state;
  UserModel newUser = UserModel();
  String userID;
  IMemeService _memeService = locator<IMemeService>();
  List<SongModel> songlist;

  AddMemeController(this.state);

  String validateImgUrl(String value) {
    if (value == null || value.length == 0) {
      return 'Enter ImgUrl ';
    }
    return null;
  }

  void saveImgUrl(String value) {
    state.memeCopy.imgUrl = value;
    state.memeCopy.email = state.user.email;
    state.memeCopy.ownerName = state.user.username;
    state.memeCopy.ownerPic = state.user.profilePic;
  }
  void deleteMeme() async {
    //print('deleting snapshot docid' + state.snapshot.snapshotId);
    try {
      _memeService.deleteMeme(state.meme.memeId);
      List<Meme> myMemesList =
          await _memeService.getMemes(state.user.uid.toString());
      await Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => MyMemesPage(state.user, myMemesList),
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
    state.memeCopy.uid = state.user.uid;
    state.memeCopy.ownerName = state.user.username;
    state.memeCopy.ownerPic = state.user.profilePic;
    state.memeCopy.timestamp = DateTime.now();

    try {
      //from add button, new meme
      if (state.meme == null) {
        await _memeService.addMeme(state.memeCopy);
      } else {
        // edit
        await _memeService.updateMeme(state.memeCopy);
      }

      state.meme = state.memeCopy;
      //prep to exit page
      List<Meme> myMemesList =
          await _memeService.getMemes(state.user.uid.toString());
      await Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => MyMemesPage(state.user, myMemesList),
          ));
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'Firestore Save Error',
          message: 'Firestore is unavailable now. Try adding snapshot later.',
          action: () {
            Navigator.pop(state.context);
            Navigator.pop(state.context, null);
          });
    }
  }
}
