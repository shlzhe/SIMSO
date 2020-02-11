import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/view/design-constants.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/login-page.dart';
import '../view/add-music-page.dart';
import '../model/entities/globals.dart' as globals;

class HomepageController {
  HomepageState state;
  IUserService _userService;
  ITimerService _timerService;
  UserModel newUser = UserModel();
  String userID;

  HomepageController(this.state, this._userService, this._timerService);

  Future addMusic() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(),
        ));
  }

  Future addMemes() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(),
        ));
  }

  Future addThoughts() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(),
        ));
  }

  Future addPhotos() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddMusic(),
        ));
  }

  void setupTimer() async {
    var timer = await _timerService.getTimer(state.user.uid, 0);
    if (timer == null) {
      timer = await _timerService.createTimer(state.user.uid);
    }

    globals.timer = timer;
    globals.timer.startTimer();
  }

  void getUserData() async {
    state.formKey.currentState.save();
    state.user = await _userService.getUserDataByID(userID);
    state.stateChanged(() => {});
  }

  void saveUser() async {
    state.formKey.currentState.save();
    state.returnedID = await _userService.saveUser(newUser);
    state.idController.text = state.returnedID;
    state.stateChanged(() => {});
    print(state.returnedID);
  }

  void saveEmail(String value) {
    newUser.email = value;
  }

  void saveUsername(String value) {
    newUser.username = value;
  }

  void saveUserID(String value) {
    userID = value;
  }

  void refreshState() {
    state.stateChanged(() => {});
  }

  void signOut(){
    //print('${state.user.email}');
    
    FirebaseAuth.instance.signOut();    //Email/pass sign out
    state.googleSignIn.signOut();       //Goole sign out
     //Display confirmation dialog box after user clicking on "Sign Out" button
    showDialog (
      context: state.context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Confirmation',style: TextStyle(color: DesignConstants.yellow,fontSize: 30),),
          content: Text('Would you like to sign out?', style: TextStyle(color: DesignConstants.yellow)) ,
          backgroundColor: DesignConstants.blue,
          actions: <Widget>[
            RaisedButton(
              child: Text('YES', style: TextStyle(color: DesignConstants.yellow,fontSize: 20),),
              color: DesignConstants.blue,
              onPressed: (){
                //Dialog box pop up to confirm signing out
                FirebaseAuth.instance.signOut();     
                //Close Drawer, then go back to Front Page
                Navigator.pop(state.context);  //Close Dialog box
                Navigator.pop(state.context);  //Close Drawer
                //Navigator.pop(state.context);  //Close Home Page 
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> LoginPage(),
                ));
              },
            ),
            RaisedButton(
              child: Text('NO', style: TextStyle(color: DesignConstants.yellow, fontSize: 20),),
              color: DesignConstants.blue,
              onPressed: ()=>Navigator.pop(state.context),  //close dialog box 
            ),
          ],
        );
        
      },
    );
  }


}
