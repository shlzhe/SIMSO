import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/song-model.dart';
import '../service-locator.dart';
import '../model/entities/user-model.dart';
import '../model/entities/snapshot-model.dart';
import '../model/entities/dictionary-word-model.dart';
import '../model/services/isnapshot-service.dart';
import '../view/mydialog.dart';
import '../view/homepage.dart';
import '../view/add-snapshot-page.dart';
import '../view/my-snapshots-page.dart';

class AddSnapshotController {
  AddSnapshotPageState state;
  UserModel newUser = UserModel();
  String userID;
  ISnapshotService _snapshotService = locator<ISnapshotService>();
  List<SongModel> songlist;

  AddSnapshotController(this.state);

  String validateImgUrl(String value) {
    if (value == null || value.length == 0) {
      return 'Enter ImgUrl ';
    }
    return null;
  }

  void saveImgUrl(String value) {
    state.snapshotCopy.imgUrl = value;
    state.snapshotCopy.email = state.user.email;
    state.snapshotCopy.ownerName = state.user.username;
    state.snapshotCopy.ownerPic = state.user.profilePic;
  }
  void deleteSnapshot() async {
    //print('deleting snapshot docid' + state.snapshot.snapshotId);
    try {
      _snapshotService.deleteSnapshot(state.snapshot.snapshotId);
      List<Snapshot> mySnapshotsList =
          await _snapshotService.getSnapshots(state.user.uid.toString());
      await Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => MySnapshotsPage(state.user, mySnapshotsList),
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
    state.snapshotCopy.uid = state.user.uid;
    state.snapshotCopy.ownerName = state.user.username;
    state.snapshotCopy.ownerPic = state.user.profilePic;
    state.snapshotCopy.timestamp = DateTime.now();

    try {
      //from add button, new snapshot
      if (state.snapshot == null) {
        await _snapshotService.addSnapshot(state.snapshotCopy);
      } else {
        // edit
        await _snapshotService.updateSnapshot(state.snapshotCopy);
      }

      state.snapshot = state.snapshotCopy;
      //prep to exit page
      List<Snapshot> mySnapshotsList =
          await _snapshotService.getSnapshots(state.user.uid.toString());
      await Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => MySnapshotsPage(state.user, mySnapshotsList),
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
