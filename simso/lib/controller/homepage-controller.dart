import 'package:flutter/material.dart';
import 'package:simso/model/entities/meme-model.dart';
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
import 'package:simso/service-locator.dart';
import 'package:simso/view/add-photo-page.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/mainChat-page.dart';
import 'package:simso/view/music-feed.dart';
import 'package:simso/view/my-memes-page.dart';
import 'package:simso/view/new-content.dart';
import 'package:simso/view/profile-page.dart';
import '../view/add-music-page.dart';
import '../view/add-thought-page.dart';
import '../model/entities/globals.dart' as globals;

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
      state.songlist.add(s);
    } else {
      //print("ERROR ADDING SONG TO LOCAL LIST");
    }
  }

  Future navigateToMemes() async {
    List<Meme> myMemesList= await memeService.getMemes(state.user.uid);
    Navigator.push(state.context, MaterialPageRoute(builder: (context)=>MyMemesPage(state.user, myMemesList)));
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

/*
  List<Message> messageCollection;
 

  try {
      //Stuff in userList
      messageCollection = await MyFirebase.getMessages(state.user.uid);
    } catch (e) {
      throw e.toString();
    }
  for(int i = 0; i< messageCollection.length; i++){
    //GET ALL MESSAGES WITH SENDER = CURRENT USER UID
    if(messageCollection[i].sender == userList[currentIndex].uid) {
      //Create a Collecion where sender is current user ONLY
      print('Testing $i:${messageCollection[i].text}');

    }   
  }
 */

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

  void snapshots() async{
    state.memesList=[];
    state.publicThoughtsList = [];
    state.imageList = await state.imageService.contentSnaps(state.friends, state.user);
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
    state.memesList=[];
    state.imageList = [];
    state.publicThoughtsList = await thoughtService.contentThoughtList(state.friends, state.user, state.user.language);
    if (state.thoughts == false){
      state.meme = false;
      state.thoughts = true;
      state.music = false;
      state.snapshots = false;
      state.stateChanged(() {});
    }
    state.stateChanged(() {});
  }

  void meme() async{
    state.publicThoughtsList = [];
    state.imageList = [];
    state.memesList = await memeService.contentMemeList(state.friends, state.user);
    if (state.meme == false) {
      state.meme = true;
      state.thoughts = false;
      state.music = false;
      state.snapshots = false;
      state.stateChanged(() {});
    }
  }

  void gotoProfile(String uid) {
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context)=> ProfilePage(state.user, true)));
  }

}
