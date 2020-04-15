import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simso/model/entities/meme-model.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import 'package:simso/model/services/imeme-service.dart';
import 'package:simso/model/services/isong-service.dart';
import 'package:simso/model/services/ithought-service.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/model/services/message-service.dart';
import 'package:simso/service-locator.dart';
import 'package:simso/view/add-photo-page.dart';
import 'package:simso/view/design-constants.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/mainChat-page.dart';
import 'package:simso/view/music-feed.dart';
import 'package:simso/view/my-memes-page.dart';
import 'package:simso/view/new-content.dart';
import 'package:simso/view/profile-page.dart';
import 'package:simso/view/search-page.dart';
import '../view/add-music-page.dart';
import '../view/add-thought-page.dart';
import '../model/entities/globals.dart' as globals;
import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';

class HomepageController {
  HomepageState state;
  ITimerService timerService;
  ITouchService touchService;
  ILimitService limitService;
  UserModel newUser = UserModel();
  List<UserModel> userList;
  List<SongModel> songList = new List<SongModel>();
  String userID;
  final ISongService _songService = locator<ISongService>();
  final IUserService _userService = locator<IUserService>();
  final IThoughtService thoughtService = locator<IThoughtService>();
  final IMemeService memeService = locator<IMemeService>();
  var unreadMessages;

  HomepageController(this.state, this.timerService, this.touchService,
      this.limitService, this.songList);

  Future addMusic() async {
    SongModel s = await Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(state.user, null),
        ));
    if (s != null) {
      print("ADD SONG TO LOCAL LIST");
      state.songs.add(s);
    } else {
      //print("ERROR ADDING SONG TO LOCAL LIST");
    }
  }

  Future navigateToMemes() async {
    List<Meme> myMemesList = await memeService.getMemes(state.user.uid);
    Navigator.push(
        state.context,
        MaterialPageRoute(
            builder: (context) => MyMemesPage(state.user, myMemesList)));
  }

  Future addThought() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddThoughtPage(state.user),
        ));
  }

  Future addPhotos() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddPhoto(state.user, null),
        ));
  }

  void setupTimer() async {
    if (globals.timer == null) {
      var timer = await timerService.getTimer(state.user.uid, 0);
      if (timer == null) {
        timer = await timerService.createTimer(state.user.uid);
      }

      globals.timer = timer;
      globals.timer.startTimer();
    }
  }

  void setupTouchCounter() async {
    if (globals.touchCounter == null) {
      var touchCounter = await touchService.getTouchCounter(state.user.uid, 0);
      if (touchCounter == null) {
        touchCounter = await touchService.createTouchCounter(state.user.uid);
      }

      globals.touchCounter = touchCounter;
      globals.touchCounter.addOne();
    }
  }

  void getLimits() async {
    if (globals.limit == null) {
      var limit = await limitService.getLimit(state.user.uid);
      if (limit == null) limit = await limitService.createLimit(state.user.uid);

      globals.limit = limit;
    }
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
    //Retrieve User Model from friendListUID
    //friendListUID only contains friend UIDs

    print('USER CURRENT INDEX: $currentIndex');
    //Navigate MainChatScreen Page
    //Passing the userList array to MainChatScreen Page
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) =>
              MainChatPage(state.user, userList, currentIndex),
        ));
  }

  void newContent() async {
    Navigator.push(state.context,
        MaterialPageRoute(builder: (context) => NewContentPage(state.user)));
  }

  void searchContent() async {
    print("search");
        Navigator.push(state.context,
        MaterialPageRoute(builder: (context) => SearchPage(state.user)));
  }

  void snapshots() async {
    state.memesList = [];
    state.friendsThoughtsList = [];
    state.allSongsList = [];
    state.imageList =
        await state.imageService.contentSnaps(state.friends, state.user);
    if (state.snapshots == false) {
      state.meme = false;
      state.thoughts = false;
      state.music = false;
      state.snapshots = true;
      state.stateChanged(() {});
    }
  }

  Future music() async {
    state.memesList = [];
    state.imageList = [];
    state.allSongsList =
        await _songService.contentSongList(state.friends, state.user);
    state.allUsersList = await _userService.readAllUser();
    if (state.music == false) {
      state.stateChanged(() {
        state.meme = false;
        state.thoughts = false;
        state.music = true;
        state.snapshots = false;
      });
    }
    state.stateChanged(() {});
  }

  void thoughts() async {
    state.memesList = [];
    state.imageList = [];
    state.allSongsList = [];
    state.friendsThoughtsList =
        await thoughtService.contentThoughtList(state.friends, state.user);

    for (Thought thought in state.friendsThoughtsList) {
      thought.text = await thoughtService.translateThought(
          state.user.language, thought.text);
    }

    if (state.thoughts == false) {
      state.meme = false;
      state.thoughts = true;
      state.music = false;
      state.snapshots = false;
      state.stateChanged(() {});
    }
    state.stateChanged(() {});
  }

  void meme() async {
    state.friendsThoughtsList = [];
    state.imageList = [];
    state.allSongsList = [];
    state.memesList =
        await memeService.contentMemeList(state.friends, state.user);
    if (state.meme == false) {
      state.meme = true;
      state.thoughts = false;
      state.music = false;
      state.snapshots = false;
      state.stateChanged(() {});
    }
  }

  Future playpause(String songUrl, bool play) async {
    AudioPlayer audioPlayer;
    var uuid = Uuid();
    //int result;
    state.stateChanged(() {
      if (play == true) {
        state.play = false;
      }
      if (play == false) {
        state.play = true;
      }
    });

    if (play && state.result == null) {
      audioPlayer = new AudioPlayer(playerId: uuid.v4());
      state.stateChanged(() {
        state.tempSongUrl = songUrl;
        state.playerId = audioPlayer.playerId;
      });
      state.result = await audioPlayer.play(songUrl);
      if (state.result == 1) {
        print("============== Play Success");
      } else {
        print("============== Play Failed");
      }
      // if (state.tempSongUrl == songUrl &&
      //     audioPlayer.playerId == state.playerId &&
      //     result != null) {
      //   int result = await audioPlayer.resume();
      //   if (result == 1) {
      //     print("============== Resume Success");
      //   } else {
      //     print("============== Resume Failed");
      //   }
      // }
      if (songUrl != state.tempSongUrl &&
          audioPlayer.playerId != state.playerId &&
          state.result == null) {
        state.stateChanged(() {
          state.tempSongUrl = songUrl;
          state.playerId = audioPlayer.playerId;
        });
        state.result = await audioPlayer.play(songUrl);
        if (state.result == 1) {
          print("============== Play Success");
        } else {
          print("============== Play Failed");
        }
      }
    } else if ((play && songUrl != state.tempSongUrl) ||
        (!play && songUrl != state.tempSongUrl)) {
      state.result = await audioPlayer.stop();
      if (state.result == 1) {
        print("============== Stop Success");
      } else {
        print("============== Stop Failed");
      }
      audioPlayer = new AudioPlayer(playerId: uuid.v4());
      state.stateChanged(() {
        state.play = true;
        state.result = null;
      });
    } else {
      state.result = await audioPlayer.pause();
      if (state.result == 1) {
        print("============== Pause Success");
      } else {
        print("============== Pause Failed");
      }
    }
  }

  //AudioPlayer audioPlayer = new AudioPlayer();
  //print("GOTHERE0");

  //int result = await audioPlayer.play(songUrl);

  // if (result == 1)
  //   print("PLAY SUCCESS");
  // else
  //   print("PLAY FAIL");

  //print("GOTHERE1");

  //  try {
  // play() async {
  // print("GOTHERE1");

  //   int result = await audioPlayer.play(songUrl);
  //   if (result == 1) {
  //     print("Song Played Successfully");
  //   }
  //  }
  // } catch (e) {
  //   print("Song Play Error: " + e.toString());

  void gotoProfile(String uid) async {
    UserModel visitUser = await _userService.readUser(uid);
    //clicking a persons name from homepage list
    Navigator.push(
        state.context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(state.user, visitUser, true)));
  }

  void getUnreadMessages() async {
    print('getUnreadMessages called');
    unreadMessages = await MyFirebase.getUnreadMessages(state.user.uid);
    //Showing toast message
    Fluttertoast.showToast(
      msg: "You have ${unreadMessages.length} unread messages",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: DesignConstants.red,
      textColor: DesignConstants.yellow,
      fontSize: 16,
    );
  }
}
