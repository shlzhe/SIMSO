import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../view/profile-page.dart';
import '../view/account-setting-page.dart';
import '../view/mainChat-page.dart';
import '../view/my-thoughts-page.dart';
import '../view/my-snapshot-page.dart';
import '../view/my-memes-page.dart';
import '../view/my-music-page.dart';
import '../view/limit-reached-dialog.dart';

import '../model/entities/meme-model.dart';
import '../model/entities/myfirebase.dart';
import '../model/entities/user-model.dart';
import '../model/entities/globals.dart' as globals;
import '../model/entities/thought-model.dart';

import 'package:simso/model/services/imeme-service.dart';
import '../model/services/ithought-service.dart';
import '../model/entities/image-model.dart';
import '../model/entities/song-model.dart';
import '../model/services/ipicture-service.dart';
import '../model/services/isong-service.dart';
import 'package:simso/model/services/ithought-service.dart';
import '../service-locator.dart';

class ProfilePageController {

  final UserModel user;
  BuildContext context;
  ProfilePageState state;
  ProfilePageController(this.state, this.user);
  List<UserModel> userList;
  UserModel newUser = UserModel();

  List<SongModel> songList = new List<SongModel>();
  String userID;
  final ISongService _songService = locator<ISongService>();
  final IMemeService memeService = locator<IMemeService>();
  final IImageService _imageService = locator<IImageService>();
  final IThoughtService _thoughtService = locator<IThoughtService>();
  final bool visit = false;

  void accountSettings() async {
    Navigator.push(
      state.context,
      MaterialPageRoute(
        builder: (context) => AccountSettingPage(
              state.user,
        )
      )
    );
  }

  void mainChatScreen() async {
    print('mainChatPage() called');
    //Retrieve all SimSo users
    try {
      //Stuff in userList
      userList = await MyFirebase.getUsers();
    } catch (e) {
      throw e.toString();
    }

    //Find current index of current user
    int currentIndex = 0;
    for (int i = 0; i < userList.length; i++) {
      if (userList[i].uid == state.user.uid) //Found index of current user
      {
        currentIndex = i;
        break;
      } else
        currentIndex++;
    }

    //In current user, find all UID of friends and fetch into friendListUID
    var friendListUID = [];
    List<UserModel> friendList;
    for (int i = 0; i < userList[currentIndex].friends.length; i++) {
      friendListUID.add(userList[currentIndex].friends[i]);
    }
    
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) =>
              MainChatPage(state.user, userList, currentIndex),
        ));
  }

  void myThoughts() async {
    List<Thought> myThoughtsList =
        await _thoughtService.getThoughts(user.uid.toString());

    Navigator.push(
        state.context,
        MaterialPageRoute(
            builder: (context) => MyThoughtsPage(state.user, myThoughtsList)));
    checkLimits();
  }

  void myMeme() async {
    List<Meme> myMemesList =
        await memeService.getMemes(user.uid.toString());
    Navigator.push(
        state.context, MaterialPageRoute(builder: (context) => MyMemesPage(state.user, myMemesList)));
    checkLimits();
  }

  void mySnapshots() async {
    List<ImageModel> imagelist;
    try {
      imagelist = await _imageService.getImage(state.user.email);
    } catch (e) {
      imagelist = <ImageModel>[];
    }

    Navigator.push(
        state.context, MaterialPageRoute(builder: (context) => SnapshotPage(state.user, imagelist)));
    checkLimits();
  }

  void myMusic() async {
    List<SongModel> songlist;
    try {
      songlist = await _songService.getSong(state.user.email);
    } catch (e) {
      songlist = <SongModel>[];
    }
    Navigator.push(
      state.context,
      MaterialPageRoute(
        builder: (context) => MyMusic(state.user, songlist),
      ),
    );
    checkLimits();
  }

    void checkLimits() async {
    var timeLimitReached = (globals.getDate(globals.limit.overrideThruDate).difference(DateTime.now()).inDays != 0
          && globals.timer.timeOnAppSec / 60 > globals.limit.timeLimitMin);
    var touchLimitReached = (globals.getDate(globals.limit.overrideThruDate).difference(DateTime.now()).inDays != 0
          && globals.touchCounter.touches > globals.limit.touchLimit);  

    if ((timeLimitReached && globals.limit.timeLimitMin > 0) || (touchLimitReached && globals.limit.touchLimit > 0)) {
      LimitReachedDialog.info(
          context: this.context, 
          user: this.user, 
          timeReached: timeLimitReached);
        print('Limit Dialog opened');
      }
  }
}
