import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/imessage-service.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/design-constants.dart';
import 'package:simso/view/mainChat-page.dart';
import 'package:simso/view/personalChatPage.dart';

import '../service-locator.dart';

class PersonalChatPageController {
  PersonalChatPageState state;
  ITimerService timerService;
  ITouchService touchService;
  UserModel user;
  List<UserModel>userList;
  List<Message>filteredMessages;
  bool publicFlag;
  String userID;
  //Constructor
  PersonalChatPageController (this.state);
  TextEditingController c;

  final IMessageService messageService = locator<IMessageService>();
  
  
 
  
  onTap(int index) async {
    print('onTap()-PersonalChat called');
    print('tapped SimSo $index');
    //Retrieve selected SimSo user
    List<UserModel> userList;
     try{
      userList = await MyFirebase.getUsers(); 
    }catch(e){
      throw e.toString();
    }
  
    //-----------
  List<Message> filteredMessages=[]; 
  
  try {
      //Stuff in userList
      filteredMessages = await MyFirebase
                   .getFilteredMessages(state.user.uid, state.userList[state.index].uid);
    } catch (e) {
      throw e.toString();
    }
  for(int i = 0; i< filteredMessages.length; i++){
    //GET ALL MESSAGES WITH SENDER = CURRENT USER UID
    
      //Create a Collecion where sender is current user ONLY
      print('(Personal Chat Testing $i:${filteredMessages[i].text}');

    
  }
    //-----------
    print('Simso username: ${userList[index].username}');
    //Navigate to personalChatPage
     Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => PersonalChatPage(state.user,index,userList,filteredMessages),   //Pass current user info + index of selected SimSo
        ));
  
  }
 FormState value;
  void send() {
    print('send() called');
    if(!state.formKey.currentState.validate()){   //NOT validated text
      
      return;
     }
      //value= state.formKey.currentState;   //Capture input message
      state.formKey.currentState.save();
      
      
     
     
  }

  String validateTextMessage(String value) {
    print(value);
    print('validateTextMessage() called');
     //Avoid null text sent
     if (value == '') {
    
    //Showing toast message
    Fluttertoast.showToast(
      msg: "Enter something first",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: DesignConstants.red,
      textColor: DesignConstants.yellow,
      fontSize: 16,
    );
      return '';
    }
    return null;
  }
  var myFriends = <UserModel>[]; 
  Future<void> saveTextMessage(String newValue) async {  //newValue is validated input text msg
    print('saveTextMessage() called');
    
    state.c.clear(); //Clear form field after sending msg
    //check info
    print('Sender: ${state.user.uid}');
    print('Sent: $newValue');
    print('Receiver:: ${state.userList[state.index].uid}');
        
    //Save text message into message collection (Firebase)

    //Capture date time for sent message
    var now=DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy - HH:mm:ss').format(now);
    

     //UPDATE FILTEREDMESSAGE
    try {
      //Stuff in userList
      filteredMessages = await MyFirebase
                   .getFilteredMessages(state.user.uid, state.userList[state.index].uid);
    } catch (e) {
      throw e.toString();
    }
    //int counter = 0;
    //------------------------------------------------------------------------
    //if(filteredMessages.length == 0) counter=1;
    //else counter=filteredMessages.length + 1;
    var messages = await messageService.getFilteredMessages(state.user.uid, state.userList[state.index].uid);
    var count = 1;
    if (messages.length > 0)
      count = messages.length + 1;
    var message = Message (
      isLike: false,
      receiver: '${state.userList[state.index].uid}',
      counter: count,
      sender: '${state.user.uid}',
      text: '$newValue',
      time: '$formattedDate',
      unread: true
    );
    await messageService.addMessage(message);
   try {
      userList = await MyFirebase.getUsers();
    } catch (e) {
      throw e.toString();
    }
      state.userList=List.from(userList);

      //DESERIALIZE FRIENDS DATA AND STORE IN A LIST<USERMODEL> ARRAY------------------
     
      for(int i = 0; i< state.user.friends.length; i++){
        QuerySnapshot querySnapshot = await Firestore.instance.collection('users')
        .where('UID',isEqualTo: state.user.friends[i])
        .getDocuments();
        for (DocumentSnapshot doc in querySnapshot.documents){
              myFriends.add(UserModel.deserialize(doc.data));
         }
      }
        //Update myFriends in UI
  
                state.stateChanged((){
                  state.friendList=List.from(myFriends);
                });
   //****************************************/
    //UPDATE FILTEREDMESSAGE
    try {
      //Stuff in userList
      filteredMessages = await MyFirebase
                   .getFilteredMessages(state.user.uid, state.userList[state.index].uid);
    } catch (e) {
      throw e.toString();
    }
  //UPDATE filteredmessages on UI
  state.stateChanged((){
      state.filteredMessages=List.from(filteredMessages);
  });
  print('UPDATE FILTER: ${state.filteredMessages.length}');
   for(int i = 0; i<state.filteredMessages.length;i++){
     print('[personal chat UI]: ${state.filteredMessages[i].text}');
   }

   //Change all received messages to unread=false
   await MyFirebase.updateUnreadMessage(state.user.uid, state.userList[state.index].uid);
  

   //-------
   //LABEL NEW MESSAGES
   //-----------------------------------------------
    var checkUnreadList = List<bool>();
    for(int i = 0; i<state.friendList.length;i++){
    var checkUnread = await MyFirebase.checkUnreadMessage(state.user.uid, state.friendList[i].uid);
        checkUnreadList.add(checkUnread);
    }
    state.stateChanged((){
      state.checkUnreadList = List.from(checkUnreadList);
    });
//-----------------------------------------------
  
//-----------------------------------------------
   List<String> latestMessages =  List<String>();
   List<String> latestDateTime = List<String>();

    for(int i = 0; i<state.friendList.length;i++){
        var messageCollection =   await MyFirebase.getFilteredMessages(state.user.uid, state.friendList[i].uid);
        if(messageCollection == null || messageCollection.length == 0)
        {
          latestMessages.add('start chatting');
          latestDateTime.add('');
        } else{
          latestMessages.add(messageCollection[messageCollection.length -1].text);
          latestDateTime.add(messageCollection[messageCollection.length -1].time);
        }
    state.stateChanged((){
      state.latestMessages = List.from(latestMessages);
      state.latestDateTime = List.from(latestDateTime);
    });
    

    }
//-----------------------------------------------
   

   //-------

  }

  favMessage(Message message) async {
    print('favMessage clicked');
    //Update message 
    await messageService.updateFavorite(message);
    //Retrieve filteredMessages and update its value on UI
    var updatedFilteredMsg = await messageService.getFilteredMessages(state.user.uid, state.userList[state.index].uid);
    state.stateChanged((){
       state.filteredMessages=List.from(updatedFilteredMsg);
    });
    
  }


  Future<void> checkAllRead() async {
    //Showing toast message
    Fluttertoast.showToast(
      msg: "All meassages are read",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: DesignConstants.red,
      textColor: DesignConstants.yellow,
      fontSize: 16,
    );
   
     //Change all received messages to unread=false
   await MyFirebase.updateUnreadMessage(state.user.uid, state.userList[state.index].uid);
  }



  Future<void> backToMainChat() async {
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
     if(state.publicFlag!=false)
    {  
      

  }}

}