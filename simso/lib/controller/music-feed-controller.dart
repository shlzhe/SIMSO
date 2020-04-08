//import 'package:flutter/material.dart';
//import 'package:simso/model/entities/song-model.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/isong-service.dart';
import 'package:simso/model/services/ithought-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
import 'package:simso/view/new-content.dart';

import '../view/music-feed.dart';

class MusicFeedController {
  MusicFeedState state;
  //NowPlayingScreenState state1;
  MusicFeedController(this.state);
  int selectedIndex = 0;
  final ISongService _songService = locator<ISongService>();
  final IUserService _userService = locator<IUserService>();
  final IThoughtService thoughtService = locator<IThoughtService>();

  void newContent() async {
    Navigator.push(state.context,
        MaterialPageRoute(builder: (context) => NewContentPage(state.user)));
  }

  void snapshots() {
    if (state.snapshots == false) {
      state.meme = false;
      state.thoughts = false;
      state.music = false;
      state.snapshots = true;
      state.stateChanged(() {});
    }
  }

  Future music() async {
    if (state.music == false) {
      state.stateChanged(() {
        state.meme = false;
        state.thoughts = false;
        state.music = true;
        state.snapshots = false;
      });
    }
    List<SongModel> allSongList;
    List<UserModel> allUserList;
    try {
      print("GET SONGS & USERS");
      allSongList = await _songService.getAllSongList();
      allUserList = await _userService.readAllUser();
    } catch (e) {
      allSongList = <SongModel>[];

      print("SONGLIST LENGTH: " + allSongList.length.toString());
    }
    print("SUCCEED IN GETTING SONGS & USERS");
    Navigator.push(
      state.context,
      MaterialPageRoute(
        builder: (context) => MusicFeed(
          state.user,
          allUserList,
          allSongList,
        ),
      ),
    );
  }

 void thoughts() async {
    state.publicThoughtsList = await thoughtService.contentThoughtList(state.friends, state.user, state.user.language);
    if (state.thoughts == false){
      state.meme = false;
      state.thoughts = true;
      state.music = false;
      state.snapshots = false;
      state.stateChanged((){});
    }
    state.stateChanged((){});
  }

  void meme() {
    if (state.meme == false) {
      state.meme = true;
      state.thoughts = false;
      state.music = false;
      state.snapshots = false;
      state.stateChanged(() {});
    }
  }
}
