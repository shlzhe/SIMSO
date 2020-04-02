import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service-locator.dart';
import '../model/entities/user-model.dart';
import '../model/entities/snapshot-model.dart';
import '../model/services/idictionary-service.dart';
import '../view/my-snapshots-page.dart';
import '../view/add-snapshot-page.dart';
import '../view/mydialog.dart';
import '../view/profile-page.dart';


class MySnapshotsController {
  MySnapshotsPageState state;
  UserModel newUser = UserModel();
  String userID;
  List<Snapshot> mySnapshotsList;
  IDictionaryService _dictionaryService = locator<IDictionaryService>();

  MySnapshotsController(this.state);

  void addSnapshot() {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddSnapshotPage(state.user, null),
        ));
  }

  void onTapSnapshot(List<Snapshot> mySnapshotsList, int index) async {
    MyDialog.showProgressBar(state.context);

    //List<String> myKeywords = await _dictionaryService.getMyKeywords(
    //    mySnapshotsList[index].snapshotId, null, null);

    await Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddSnapshotPage(
            state.user,
            state.mySnapshotsList[index],
            //myKeywords,
          ),
        ));
    Navigator.pop(state.context);
  }

    void onTapProfile(List<Snapshot> mySnapshotsList, int index) async {
    MyDialog.showProgressBar(state.context);

    //List<String> myKeywords = await _dictionaryService.getMyKeywords(
    //    mySnapshotsList[index].snapshotId, null, null);

    await Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            state.user,
            //myKeywords,
          ),
        ));
    Navigator.pop(state.context);
  }
}
