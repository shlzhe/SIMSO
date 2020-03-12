import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../view/mydialog.dart';
import '../view/account-setting-page.dart';
import '../service-locator.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/entities/globals.dart' as globals;
import '../view/login-page.dart';
import 'package:simso/view/design-constants.dart';

class AccountSettingController {
  AccountSettingPageState state;
  IUserService userService = locator<IUserService>();
  AccountSettingController(this.state);

  void saveUserName(String value) {
    state.userCopy.username = value;
  }

  void saveCity(String value) {
    state.userCopy.city = value;
  }

  void saveGender(String value) {
    state.userCopy.gender = value;
  }

  void saveAge(int value) {
    state.userCopy.age = value;
  }

  void saveAboutMe(String value) {
    state.userCopy.aboutme = value;
  }

  void saveEmail(String value) {
    state.userCopy.email = value;
  }

  void savePassword(String value) {
    if (state.changing_s == true) {
      userService.changePassword(state.user, value);
    } else
      return;
  }

  void deleteUser() {
    //Display confirmation dialog box after user clicking on "Sign Out" button
    showDialog(
      context: state.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are You Sure?',
            style: TextStyle(color: DesignConstants.yellow, fontSize: 30),
          ),
          content: Text(
              'If you delete your account, there will be no way to get it back!',
              style: TextStyle(color: DesignConstants.yellow)),
          backgroundColor: DesignConstants.blue,
          actions: <Widget>[
            RaisedButton(
              child: Text(
                'YES',
                style: TextStyle(color: DesignConstants.yellow, fontSize: 20),
              ),
              color: DesignConstants.blue,
              onPressed: () {
                userService.deleteUser(state.user);
                //Close Drawer, then go back to Front Page
                Navigator.pop(context); //Close Dialog box
                Navigator.pop(context); //Close Drawer
                //Navigator.pop(state.context);  //Close Home Page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
            ),
            RaisedButton(
              child: Text(
                'NO',
                style: TextStyle(color: DesignConstants.yellow, fontSize: 20),
              ),
              color: DesignConstants.blue,
              onPressed: () => Navigator.pop(context), //close dialog box
            ),
          ],
        );
      },
    );
  }

  void save() async {
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();
    try {
      await userService.updateUserDB(state.userCopy);
      showSnackBar('Saved!');
      if (state.changing_s == true) {
        showDialog(
            context: state.context,
            builder: (context) => new AlertDialog(
                  title: new Text('Please Sign In Again'),
                  content: new Text(
                      'We find that you have changed your password. For your safety, please sign in again with your new password!'),
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut(); //Email/pass sign out
                        GoogleSignIn().signOut();
                        globals.timer = null;
                        globals.touchCounter = null;
                        Navigator.push(
                            state.context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      },
                      child: Text("OK"),
                    ),
                  ],
                ));
      }

      state.stateChanged(() {
        state.changing = false;
        state.changing_p = false;
        state.formKey.currentState.reset();
      });
    } catch (e) {
      MyDialog.info(
          context: state.context,
          title: 'Firestore Save Error',
          message: 'Firestore is unavailable now. Try again later',
          action: () {
            Navigator.pop(state.context);
            Navigator.pop(state.context, null);
          });
    }
  }

  Future<bool> onBackPressed() {
    if (state.changing || state.changing_p == true) {
      return showDialog(
        context: state.context,
        builder: (context) => new AlertDialog(
          title: new Text('Not Saving'),
          content: new Text('Your editing is not saved'),
          actions: <Widget>[
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text("Stay"),
            ),
            SizedBox(height: 16),
            new GestureDetector(
              onTap: () {
                save();
                Navigator.of(context).pop(true);
              },
              child: Text("Save&Leave"),
            ),
          ],
        ),
      );
    } else
      Navigator.of(state.context).pop(true); //??false;
  }

  void showSnackBar(String label) {
    state.scaffoldKey.currentState.removeCurrentSnackBar();
    state.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(
          label,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
