
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simso/controller/firebase.dart';
import 'package:simso/view/create-account.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/login-page.dart';
import 'package:simso/view/mydialog.dart';

class LoginPageController{
  
  LoginPageState state;

  LoginPageController(this.state);

  void goToHomepage() async{
    if(!state.formKey.currentState.validate()){
      return;
    }
    state.formKey.currentState.save();
    print(state.user.email);
    MyDialog.showProgressBar(state.context);
    try{
      state.user.uid = await FirebaseFunctions.login(state.user.email, state.user.password);
      if (state.user.uid!=''||state.user.uid!=null){
        state.user = await FirebaseFunctions.readUser(state.user.uid);
        state.stateChanged((){});
      }
      }
    catch(error){
       MyDialog.popProgressBar(state.context);
      MyDialog.info(
        
        context: state.context,
        title: 'Login Error',
        message: error.message != null ? error.message: error.toString(),
        action: () => Navigator.pop(state.context),
      );
        return;  //Do not proceed if log in failed
    }
    if (state.user.uid!=null|| state.user.uid !=''){
      MyDialog.popProgressBar(state.context);
      Navigator.push(state.context,MaterialPageRoute(
      builder: (context) => Homepage(state.user),
      ));
    }
    else return null;
    //need to send message of success or failure. need to create a load in progress indicator.
  }

  String validateEmail(String value) {
    if (!(value.contains('@') || value.contains('.')) || value.contains(' ')){
      return '  Invalid email format. \n  Must contain @ and . \n  Also no empty spaces.';
    }
    return null;
  }

  void saveEmail(String newValue) {
    state.user.email = newValue;
  }

  String validatePassword(String value) {
    if (value.length < 5){
      return '  Please enter at least 5 characters.';
    }
    return null;
  }

  void savePassword(String newValue) {
    state.user.password = newValue;
  }

  void createAccount() {
    Navigator.push(state.context,MaterialPageRoute(
      builder: (context) => CreateAccount(),
      ));
  }

  void entry(String value) {
    if (value!=null){
      state.entry = true;
    }
    if (value=='') state.entry = false;
    state.stateChanged((){});
  }

  void googleSignIn(){
    print('googleSignIn() called');
    /*
    //Push to Google Sign In Page 
    Navigator.push(state.context,MaterialPageRoute(
      builder: (context)=> GoogleSignInPage(state.user)
            ));
    */
    signInWithGoogle().whenComplete((){
      Navigator.of(state.context).push(
        MaterialPageRoute(builder: (context)=>Homepage(state.user)
        )); 
    });
        }

  //CREATE 2 METHODS FOR GOOGLE SIGN IN 
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await state.googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

    //Checking gmail acct and pass validation
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await state.auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await state.auth.currentUser();
  print('UID: + ${user.uid}');
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';



  }

  void signOutGoogle() async{
    await state.googleSignIn.signOut();

  print("Google User Sign Out");
  }


}

    
  