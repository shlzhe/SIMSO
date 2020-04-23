import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../view/profile-page.dart';
import '../view/account-setting-page.dart';
import '../view/mainChat-page.dart';
import '../view/visit-thoughts-page.dart';
import '../view/visit-memes-page.dart';
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
  final UserModel currentUser;
  final UserModel visitUser;
  BuildContext context;
  ProfilePageState state;
  ProfilePageController(this.state, this.currentUser, this.visitUser);
  List<UserModel> userList;
  UserModel newUser = UserModel();

  List<SongModel> songList = new List<SongModel>();
  String userID;
  final ISongService _songService = locator<ISongService>();
  final IMemeService _memeService = locator<IMemeService>();
  final IImageService _imageService = locator<IImageService>();
  final IThoughtService _thoughtService = locator<IThoughtService>();
  final bool visit = false;

  void accountSettings() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
            builder: (context) => AccountSettingPage(
                  state.currentUser,
                )));
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
      if (userList[i].uid ==
          state.currentUser.uid) //Found index of current user
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
              MainChatPage(state.currentUser, userList, currentIndex),
        ));
  }

  void goTo(int index) async {
    if (index == 0) {
      List<Thought> thoughtsList = [];

      if (state.currentUser.uid == state.visitUser.uid ||
          state.visitUser == null) {
        //user wants to visit their own thoughts
        try {
          thoughtsList =
              await _thoughtService.getThoughts(state.currentUser.uid);
          Navigator.push(
              state.context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyThoughtsPage(state.currentUser, thoughtsList)));
        } catch (e) {
          print(e);
        }
      } else {
        //user wants to visit another person's thoughts
        try {
          thoughtsList = await _thoughtService.getThoughts(state.visitUser.uid);

          for (Thought thought in thoughtsList) {
            var tempText = await _thoughtService.translateThought(
                state.currentUser.language, thought.text);
            if (tempText != null) thought.text = tempText;
          }

          Navigator.push(
              state.context,
              MaterialPageRoute(
                  builder: (context) =>
                      VisitThoughtsPage(currentUser, visitUser, thoughtsList)));
        } catch (e) {
          print(e);
        }
      }
    }
    if (index == 1) {
      //Meme
      List<Meme> memesList = [];

      if (state.currentUser.uid == state.visitUser.uid ||
          state.visitUser == null) {
        //user wants to visit their own memes
        try {
          memesList = await _memeService.getMemes(state.currentUser.uid);
          Navigator.push(
              state.context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyMemesPage(state.currentUser, memesList)));
        } catch (e) {
          print(e);
        }
      } else {
        //user wants to visit another person's memes
        try {
          memesList = await _memeService.getMemes(state.visitUser.uid);

          // for (Meme meme in memesList) {
          //   meme.text = await _memeService.translateThought(
          //       state.currentUser.language, thought.text);
          // }

          Navigator.push(
              state.context,
              MaterialPageRoute(
                  builder: (context) =>
                      VisitMemesPage(currentUser, visitUser, memesList)));
        } catch (e) {
          print(e);
        }
      }
    }
    if (index == 2) {
      List<ImageModel> imagelist;
      try {
        imagelist = await _imageService.getImage(state.visitUser.email);
      } catch (e) {
        imagelist = <ImageModel>[];
      }

      Navigator.push(
          state.context,
          MaterialPageRoute(
              builder: (context) => SnapshotPage(state.visitUser, imagelist)));
      checkLimits();
    }
    if (index == 3) {
      print('music');
      List<SongModel> songlist;
      try {
        songlist = await _songService.getSong(state.visitUser.email);
      } catch (e) {
        songlist = <SongModel>[];
      }
      Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => MyMusic(state.visitUser, songlist),
        ),
      );
      checkLimits();
    }
  }

  void checkLimits() async {
    var timeLimitReached = (globals
                .getDate(globals.limit.overrideThruDate)
                .difference(DateTime.now())
                .inDays !=
            0 &&
        globals.timer.timeOnAppSec / 60 > globals.limit.timeLimitMin);
    var touchLimitReached = (globals
                .getDate(globals.limit.overrideThruDate)
                .difference(DateTime.now())
                .inDays !=
            0 &&
        globals.touchCounter.touches > globals.limit.touchLimit);

    if ((timeLimitReached && globals.limit.timeLimitMin > 0) ||
        (touchLimitReached && globals.limit.touchLimit > 0)) {
      LimitReachedDialog.info(
          context: this.context,
          user: this.currentUser,
          timeReached: timeLimitReached);
      print('Limit Dialog opened');
    }
  }
}
