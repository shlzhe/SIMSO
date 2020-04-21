import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simso/model/entities/call-model.dart';
import 'package:simso/model/entities/meme-model.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/icall-service.dart';
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
  AudioPlayer audioPlayer = new AudioPlayer(playerId: null);
  HomepageState state;
  ITimerService timerService;
  ITouchService touchService;
  ILimitService limitService;
  UserModel newUser = UserModel();
  List<UserModel> userList;
  List<SongModel> songList = new List<SongModel>();
  String userID;
  int result;
  final ISongService _songService = locator<ISongService>();
  final IUserService _userService = locator<IUserService>();
  final IThoughtService thoughtService = locator<IThoughtService>();
  final IMemeService memeService = locator<IMemeService>();
  final ICallService callService = locator<ICallService>();
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

  void setUpCheckCall(BuildContext thisContext) async {
    print("me===");
    Call call = new Call.isEmpty();
    globals.call = call;
    globals.user = state.user;
    globals.call.startCallCheck(state.user.uid, state.context);
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
    state.stateChanged(() {
      state.leave = true;
    });
    Navigator.push(
      state.context,
      MaterialPageRoute(
        builder: (context) => NewContentPage(state.user),
      ),
    );
  }

  void searchContent() async {
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

  Future playFunc(String songUrl) async {
    var uuid = Uuid();

    playSong() async {
      try {
        result = await audioPlayer.play(songUrl);
        if (result == 1) {
          print("============== Play Success");
        } else {
          print("============== Play Failed");
        }
      } catch (e) {
        print("Play Error: " + e.toString());
      }
    }

    stopSong() async {
      try {
        result = await audioPlayer.stop();
        if (result == 1) {
          print("============== Stop Success");
        } else {
          print("============== Stop Failed");
        }
      } catch (e) {
        print("Stop Song Error: " + e.toString());
      }
    }

    if (state.play == false && state.pause == true) {
      if (state.playerId == "") {
        audioPlayer = new AudioPlayer(playerId: uuid.v4());
        //print("============= 1st playerId: " + audioPlayer.playerId.toString());
        state.stateChanged(() {
          state.tempSongUrl = songUrl;
          state.playerId = audioPlayer.playerId;
        });
        playSong();
        state.stateChanged(() {
          state.play = true;
          state.pause = false;
        });
      } else {
        playSong();
        state.stateChanged(() {
          state.play = true;
          state.pause = false;
        });
      }
    }

    if (state.play == true &&
        state.pause == false &&
        songUrl != state.tempSongUrl) {
      await stopSong();
      state.stateChanged(() {
        //print("************* PLAY NEW SONG FRM PAUSE **************");
        audioPlayer = new AudioPlayer(playerId: uuid.v4());
        // print("============= Subsequent new playerId: " +
        //     audioPlayer.playerId.toString());

        state.play = true;
        state.pause = false;
        state.tempSongUrl = songUrl;
        state.playerId = audioPlayer.playerId;
        playSong();
      });
    }
  }

  Future pauseFunc(String songUrl) async {
    var uuid = Uuid();

    playSong() async {
      try {
        result = await audioPlayer.play(songUrl);
        if (result == 1) {
          print("============== Play Success");
        } else {
          print("============== Play Failed");
        }
      } catch (e) {
        print("Play Error: " + e.toString());
      }
    }

    stopSong() async {
      try {
        result = await audioPlayer.stop();
        if (result == 1) {
          print("============== Stop Success");
        } else {
          print("============== Stop Failed");
        }
      } catch (e) {
        print("Stop Song Error: " + e.toString());
      }
    }

    pauseSong() async {
      try {
        result = await audioPlayer.pause();
        if (result == 1) {
          print("============== Pause Success");
        } else {
          print("============== Pause Failed");
        }
      } catch (e) {
        print("Pause Error: " + e.toString());
      }
    }

    if (state.play == true && state.pause == false) {
      if (songUrl != state.tempSongUrl) {
        //print("************* PLAY NEW SONG FRM PLAY **************");
        await stopSong();
        state.stateChanged(() {
          audioPlayer = new AudioPlayer(playerId: uuid.v4());
          // print("============= Subsequent new playerId: " +
          //     audioPlayer.playerId.toString());
          //pause = true;
          state.play = true;
          state.pause = false;
          state.tempSongUrl = songUrl;
          state.playerId = audioPlayer.playerId;
          playSong();
        });
      } else {
        pauseSong();
        state.stateChanged(() {
          state.pause = true;
          state.play = false;
        });
      }
    }
  }

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
  }
}
