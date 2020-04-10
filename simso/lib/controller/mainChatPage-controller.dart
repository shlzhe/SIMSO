import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/model/services/message-service.dart';
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
    var myFriends = <UserModel>[]; 

    try {
      state.stateChanged(() {
        state.friendFlag = true;
        state.publicFlag = false; //To display public button
        
      });
    } catch (e) {
      throw e.toString();
    }

       try {
      userList = await MyFirebase.getUsers();
    } catch (e) {
      throw e.toString();
    }
      state.userList=List.from(userList);

      //DESERIALIZE FRIENDS DATA AND STORE IN A LIST<USERMODEL> ARRAY------------------
     
      for(int i = 0; i< state.userList[state.currentIndex].friends.length; i++){
        QuerySnapshot querySnapshot = await Firestore.instance.collection('users')
        .where('UID',isEqualTo: state.userList[state.currentIndex].friends[i])
        .getDocuments();
        for (DocumentSnapshot doc in querySnapshot.documents){
              myFriends.add(UserModel.deserialize(doc.data));
         }
      }
        //Update myFriends in UI
           
                state.stateChanged((){
                  state.friendList=List.from(myFriends);
                });
      print('FRIENDS: ${state.friendList.length}');
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

  onTapPublishMode(int index) async {

    print('tapped SimSo-MainChat $index');
    //print('Current user: ${state.user.username}');
    //print('Receiver: ${state.userList[index].username}');
     //-----------
      List<Message> filteredMessages=[]; 
  
try {
      //Stuff in userList
      filteredMessages = await MyFirebase
                   .getFilteredMessages(state.user.uid, state.userList[index].uid);
    } catch (e) {
      throw e.toString();
    }
for(int i = 0; i< filteredMessages.length; i++){
    //GET ALL MESSAGES WITH SENDER = CURRENT USER UID
    
      //Create a Collecion where sender is current user ONLY
      print('([Main Chat] $i:${filteredMessages[i].text}');

    
  }
    //-----------


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
          builder: (context) => PersonalChatPage(state.user, index,userList,filteredMessages), 
          //Pass current user info + index of selected SimSo
        ));
  }
//================
  void onTapFriendMode(int index) async {
    print('ontapFriendMode called');
    print('tapped: $index');
    //*****
    List<Message> filteredMessages=[]; 
  
      try {
          //Stuff in userList
          filteredMessages = await MyFirebase
                   .getFilteredMessages(state.user.uid, state.friendList[index].uid);
        } catch (e) {
            throw e.toString();
     }
    for(int i = 0; i< filteredMessages.length; i++){
    //GET ALL MESSAGES WITH SENDER = CURRENT USER UID
    
      //Create a Collecion where sender is current user ONLY
      print('([Main Chat] $i:${filteredMessages[i].text}'); 
  }
    //GET ALL USERS
    try {
      userList = await MyFirebase.getUsers();
    } catch (e) {
      throw e.toString();
    }
    //CONVERT FRIEND INDEX TO USERLIST INDEX
    for(int i = 0; i<userList.length; i++){
        //Compare friendList selected uid with userList uid
      if(userList[i].uid == state.friendList[index].uid) {    //matched,then convert friendList index to userList index
          index = i;
          break;                                              //exit loop
        }
    }
 
    print('Simso username: ${userList[index].username}');
  
    //Navigate to personalChatPage
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => PersonalChatPage(state.user, index,userList,filteredMessages), 
          //Pass current user info + index of selected SimSo
        ));
    
    //-------


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
                state.currentIndex), //Pass current user info + index of selected SimSo
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
            builder: (context) => MainChatPage(state.user,userList,state.currentIndex), 
            //Pass current user info + index of selected SimSo
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
   var unreadMessages;
  Future<List<Message>> getUnreadMessages() async {
    print('getUnreadMessages() in mainChatPage');
    unreadMessages = await MyFirebase.getUnreadMessages(state.user.uid);
    return unreadMessages;
  }
}
