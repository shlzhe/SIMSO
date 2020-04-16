import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service-locator.dart';
import '../model/entities/user-model.dart';
import '../model/entities/meme-model.dart';
import '../model/services/idictionary-service.dart';
import '../view/my-memes-page.dart';
import '../view/add-meme-page.dart';
import '../view/mydialog.dart';
import '../view/profile-page.dart';

final bool visit = false;

class MyMemesController {
  MyMemesPageState state;
  UserModel newUser = UserModel();
  String userID;
  List<Meme> myMemesList;
  IDictionaryService _dictionaryService = locator<IDictionaryService>();

  MyMemesController(this.state);

  void addMeme() {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMemePage(state.user, null),
        ));
  }

  void onTapMeme(List<Meme> myMemesList, int index) async {
    MyDialog.showProgressBar(state.context);

    //List<String> myKeywords = await _dictionaryService.getMyKeywords(
    //    mySnapshotsList[index].snapshotId, null, null);

    await Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMemePage(
            state.user,
            state.myMemesList[index],
            //myKeywords,
          ),
        ));
    Navigator.pop(state.context);
  }

  void onTapProfile(List<Meme> myMemesList, int index) async {
    MyDialog.showProgressBar(state.context);

    //List<String> myKeywords = await _dictionaryService.getMyKeywords(
    //    mySnapshotsList[index].snapshotId, null, null);

    await Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(state.user, null, visit
              //myKeywords,
              ),
        ));
    Navigator.pop(state.context);
  }
}
