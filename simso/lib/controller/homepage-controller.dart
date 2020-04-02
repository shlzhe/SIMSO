import 'package:flutter/material.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import 'package:simso/model/services/ithought-service.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
import 'package:simso/view/add-photo-page.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/mainChat-page.dart';
import 'package:simso/view/new-content.dart';
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
  IUserService userService = locator<IUserService>();
  final IThoughtService thoughtService = locator<IThoughtService>();

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
      print("ERROR ADDING SONG TO LOCAL LIST");
    }
  }

  Future addMemes() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: null,
        ));
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
  int currentIndex=0;
   for(int i = 0; i<userList.length; i++){
      if(userList[i].uid == state.user.uid)   //Found index of current user
         {
          currentIndex = i;
          break;                                
         }else currentIndex++;
    }

  //In current user, find all UID of friends and fetch into friendListUID
  var friendListUID=[];
  List<UserModel>friendList;
  for(int i = 0; i<userList[currentIndex].friends.length; i++){
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
          builder: (context) => MainChatPage(state.user,userList,currentIndex),
        ));
  }

  void newContent() async {
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context)=>NewContentPage(state.user)));
  }

  void snapshots() {
    if (state.snapshots == false){
      state.meme = false;
      state.thoughts = false;
      state.music = false;
      state.snapshots = true;
      state.stateChanged((){});
    }
  }

  void music() {
    if (state.music == false){
      state.stateChanged((){
        state.meme = false;
        state.thoughts = false;
        state.music = true;
        state.snapshots = false;
      });
    }
  }

  void thoughts() async {
    state.publicThoughtsList = await thoughtService.contentThoughtList(state.friends, state.user.friends, state.user.language);
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
    if (state.meme == false){
      state.meme = true;
      state.thoughts = false;
      state.music = false;
      state.snapshots = false;
      state.stateChanged((){});
    }
  }
}
