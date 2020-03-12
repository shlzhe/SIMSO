import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/design-constants.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/mainChat-page.dart';
import 'package:simso/view/personalChatPage.dart';

class MainChatPageController {
  MainChatPageState state;
  ITimerService timerService;
  ITouchService touchService;
  UserModel user;
  List<UserModel> userList;
  List<SongModel> songList;

  bool publicFlag;
  bool friendFlag;
  String userID;

  //Constructor
  MainChatPageController(this.state);

  Future<void> showUsers() async {
    print('showUsers() called');
    publicFlag = true;
    state.friendFlag = false; //To display Friend button
    try {
      print('${state.userList.length.toString()}');
      state.stateChanged(() {
        state.publicFlag = true;
      });
    } catch (e) {
      throw e.toString();
    }
    //Showing toast message
    Fluttertoast.showToast(
      msg: "Public Mode",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: DesignConstants.red,
      textColor: DesignConstants.yellow,
      fontSize: 16,
    );
  }

  Future<void> showFriends() async {
    print('showFriends() called');

    //---------------------------------------------------------------------------
    //print('# friends: ${state.userList[state.currentIndex].friends.length}');
    //print(' Current friends of ${state.user.username}: ');

    try {
      //print('${state.userList.length.toString()}');
      state.stateChanged(() {
        state.friendFlag = true;
        state.publicFlag = false; //To display public button
      });
    } catch (e) {
      throw e.toString();
    }
    //print(' Current friends: ${state.userList[index].friends}');
    //Showing toast message
    if (state.userList[state.currentIndex].friends.isEmpty ||
        state.userList[state.currentIndex].friends.length == 0) {
      Fluttertoast.showToast(
        msg: "You have no friend",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: DesignConstants.red,
        textColor: DesignConstants.yellow,
        fontSize: 16,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Friend Mode",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: DesignConstants.red,
        textColor: DesignConstants.yellow,
        fontSize: 16,
      );
    }
  }

  onTap(int index) async {
    print('tapped SimSo $index');
    //Retrieve selected SimSo user
    List<UserModel> allUsers;
    try {
      userList = await MyFirebase.getUsers();
    } catch (e) {
      throw e.toString();
    }

    print('Simso username: ${userList[index].username}');
    //Navigate to personalChatPage
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => PersonalChatPage(state.user, index,
              userList), //Pass current user info + index of selected SimSo
        ));
  }

  void backButton() async {
    print('backButton() called');
    //Navigate to default Main Chat Page
    if (state.publicFlag == true) {
      state.publicFlag = false;
      List<UserModel> userList;
      try {
        userList = await MyFirebase.getUsers();
      } catch (e) {
        throw e.toString();
      }
      Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => MainChatPage(
                state.user,
                userList,
                state
                    .currentIndex), //Pass current user info + index of selected SimSo
          ));
    } else if (state.friendFlag == true) {
      state.friendFlag = false;
      List<UserModel> userList;
      try {
        userList = await MyFirebase.getUsers();
      } catch (e) {
        throw e.toString();
      }
      Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => MainChatPage(
                state.user,
                userList,
                state
                    .currentIndex), //Pass current user info + index of selected SimSo
          ));
    } else if (state.publicFlag == false && state.friendFlag == false) {
      //Navigate to Home Page
      Navigator.push(
          state.context,
          MaterialPageRoute(
            builder: (context) => Homepage(state.user, songList),
          ));
    }
  }
}
