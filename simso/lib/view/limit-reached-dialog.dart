import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import '../model/entities/globals.dart' as globals;
import '../service-locator.dart';
import 'design-constants.dart';
import '../model/entities/local-user.dart' as local;
import 'login-page.dart';

class LimitReachedDialog {
  static void info(
      {@required BuildContext context,
      @required bool timeReached,
      @required UserModel user}) {

      String title = timeReached ? 'Time' : 'Touch';
      title += ' limit reached';
      String message = '\nWould you like to ignore your limit for today or log off?';
      Function ignoreLimit = () {
        ILimitService limitService = locator<ILimitService>();
        var ourDate = DateTime.now();
        var day = ourDate.day;
        var month = ourDate.month;
        var year = ourDate.year;
        globals.limit.overrideThruDate =  '$month/$day/$year';
        limitService.updateLimit(globals.limit);
        Navigator.pop(context);
      };
      Function logOut = () async {
        var localUserFunction = local.LocalUser();
        String readInData = await localUserFunction.readLocalUser();
        String credential = await localUserFunction.readCredential();
        int i = readInData.indexOf(' ');
        user.email = readInData.substring(0,i);
        user.password= readInData.substring(i+1);
        FirebaseAuth.instance.signOut();    //Email/pass sign out
        GoogleSignIn().signOut();
        //Display confirmation dialog box after user clicking on "Sign Out" button
        
        FirebaseAuth.instance.signOut();
        globals.timer.stopTimer();
        globals.timer = null;
        globals.touchCounter = null;
        globals.limit = null;
        //Close Drawer, then go back to Front Page
        Navigator.pop(context);  //Close Dialog box
        Navigator.pop(context);  //Close Drawer
        //Navigator.pop(state.context);  //Close Home Page 
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> LoginPage(
            localUserFunction: localUserFunction, 
            credential: credential=='true'? credential: null,
            email: credential=='true'? user.email: null,
            password: credential=="true"? user.password: null,
            ),
        ));
      };
  
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Container(
              height: 120,
              child: Column(
                children: <Widget>[
                  Icon(
                    timeReached ? Icons.hourglass_empty : Icons.touch_app,
                    size: 50,
                    color: Colors.red,
                  ),
                  Expanded(child: Text(message)),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: logOut,
              ),
              RaisedButton(
                child: Text(
                  'Ignore Limit',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: ignoreLimit,
              ),
            ],
          );
        },
      );
      
    }
  
    static LocalUser() {}

  
}