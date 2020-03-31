import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/design-constants.dart';
import 'package:simso/view/mainChat-page.dart';
import 'package:simso/view/personalChatPage.dart';

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
    int counter=0;
    //------------------------------------------------------------------------
    if(filteredMessages.length == 0) counter=1;
    else counter=filteredMessages.length + 1;
    //Adding a new DocumentReference to messages
    Firestore.instance.collection('messages').document().
      setData({
        'isLike': 'false',
        'receiver': '${state.userList[state.index].uid}',
        'sender': '${state.user.uid}',
        'text': '$newValue',
        'time': '$formattedDate',
        'unread': 'true',
        'counter': counter,
      });
   
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

  }

  
}