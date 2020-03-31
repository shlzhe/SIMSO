import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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
  bool publicFlag;
  String userID;
  //Constructor
  PersonalChatPageController (this.state);
  TextEditingController c;

  
  onTap(int index) async {
    print('tapped SimSo $index');
    //Retrieve selected SimSo user
    List<UserModel> userList;
     try{
      userList = await MyFirebase.getUsers(); 
    }catch(e){
      throw e.toString();
    }
    print('Simso username: ${userList[index].username}');
    //Navigate to personalChatPage
     Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => PersonalChatPage(state.user,index,userList),   //Pass current user info + index of selected SimSo
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

  void saveTextMessage(String newValue) {  //newValue is validated input text msg
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
    
    print('Now: $formattedDate');

    //Adding a new DocumentReference to messages
    Firestore.instance.collection('messages').document().
      setData({
        'isLike': 'false',
        'receiver': '${state.userList[state.index].uid}',
        'sender': '${state.user.uid}',
        'text': '$newValue',
        'time': '$formattedDate',
        'unread': 'true',
      });

    //Collect all message pieces



  }

  
}