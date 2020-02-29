import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/entities/local-user.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/view/create-account.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/login-page.dart';
import 'package:simso/view/mydialog.dart';

class LoginPageController{
  LoginPageState state;
  IUserService userService;
  final LocalUser localUser;
  
  LoginPageController(this.state, this.userService, this.localUser);

  void goToHomepage() async{
    if(!state.formKey.currentState.validate()){
      return;
    }
    state.formKey.currentState.save();
    MyDialog.showProgressBar(state.context);
    try{
      state.user.uid = await userService.login(state.user);
      if (state.user.uid!=''||state.user.uid!=null){
        if (state.setTouchID) state.writeLocalUser(state.user);
        state.user = await userService.readUser(state.user.uid);
        state.stateChanged((){});
      }
    }
    catch(error){
       MyDialog.popProgressBar(state.context);
      MyDialog.info(
        
        context: state.context,
        title: 'Login Error',
        message: 'Invalid username or password! \nTry again!',
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
    if (!(value.contains('@') || value.contains('.'))){
      return '  Invalid email format. \n  Must contain @ and . \n  Also no empty spaces.';
    }
    return null;
  }

  void saveEmail(String newValue) {
    newValue = newValue.replaceAll(' ', '');
    state.user.email = newValue.replaceAll(String.fromCharCode(newValue.length-1), '');
  }

  String validatePassword(String value) {
    if (value.length <= 5){
      return '  Please enter at least 6 characters.';
    }
    return null;
  }

  void savePassword(String newValue) {
    newValue = newValue.replaceAll(' ', '');
    state.user.password = newValue.replaceAll(String.fromCharCode(newValue.length-1), '');
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
    signInWithGoogle().whenComplete(() {
      //Retrieve UID from userProfile in Firebase
     
                  


      //Compare signed in UID with every single element 

      //If signed in UID has not stored, create a new document ID for this UID

    


      
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
  print('GOOGLE UID: + ${user.uid}');

  //------
   try{
                    QuerySnapshot querySnapshot = await Firestore.instance.collection('users')
                                            .getDocuments();
                    var users = <UserModel>[];  //List array
                    if(querySnapshot == null || querySnapshot.documents.length == 0){
                    print('no docID found');
                    //return users;
                  }
                   bool matchedUID = false;
                  //---------------------------------------------------------
                  //PRINT ALL DOCUMENT ID IN USERS COLLECTION (FIREBASE)
                  for(DocumentSnapshot doc in querySnapshot.documents){
                    
                  //spaces.add(Space.deserialize(doc.data, doc.documentID));
                        //testing
                        //print('Selected (users collection) docID: ${doc.documentID}');
                  //---------------------------------------------------------
                        if(doc.documentID == user.uid) {
                          matchedUID = true;
                          break;   
                        } //no matchedUID
                   
                    }  //end FOR loop
                if(matchedUID == true){
                  // NO CREATION OF NEW DOCUMENT ID
                  //Only Direct to Home Page
                   Navigator.of(state.context).push(
                       MaterialPageRoute(builder: (context)=>Homepage(state.user)
               )); 
                } else{
                  // CREATION OF NEW DOCUMENT ID
                    //------------------------------------------------------------
                    state.user.uid = user.uid;
                    //TRIM USERNAME FROM GOOGLE ACCOUNT
                    int iend = user.email.indexOf('@');
                    String substring = user.email.substring(0 , iend);
                    state.user.username = substring;     //Set username as Google acount trimmed until '@'
                    
                    //-----------------------------------
                    state.user.email=user.email;         //Set email as input email
                    if (state.user.uid!=''||state.user.uid!=null){
                    userService.createUserDB(state.user);
                      }
                    //------------------------------------------------------------
                    //Direct to Home Page
                    Navigator.of(state.context).push(
                       MaterialPageRoute(builder: (context)=>Homepage(state.user)

               )); 
                }
                      
                  }catch(e){
                    throw e;
                  }

  //------




  
  assert(user.uid == currentUser.uid);
  return 'signInWithGoogle succeeded: $user';


  }

  void signOutGoogle() async{
    await state.googleSignIn.signOut();

  print("Google User Sign Out");
  }
  Future<void> checkBiometric() async {
    try{
      // state.checkBiometric = await state.bioAuth.canCheckBiometrics;
      // print(state.checkBiometric);
      state.readLocalUser();
      state.biometricList = await state.bioAuth.getAvailableBiometrics();
      if(state.biometricList.length<1) {
        MyDialog.info(
          context: state.context, 
          title: 'Biometric Authentication Error', 
          message: state.readInData!=null?'No Biometric hardware available'
            :
            'You need to setup/link your fingerprint to an account!', 
          action: (){Navigator.pop(state.context);});
      }
      else
      // state.checkBiometric = false;
      {
        state.checkBiometric = await state.bioAuth.authenticateWithBiometrics(
        localizedReason: 'Checking Fingerprint',
        useErrorDialogs: true,
        stickyAuth: true);
        if (state.checkBiometric) {
          // state.localuser();
          state.readLocalUser();
          print(state.readInData);
          int i = state.readInData.indexOf(' ');
          state.user.email = state.readInData.substring(0,i);
          state.user.password=state.readInData.substring(i+1);
          if (state.user.email!=''&&state.user.password!=''){
            userService.login(state.user)
              .then((value) => 
                Navigator.push(state.context, MaterialPageRoute(
                  builder: (context)=>Homepage(state.user))),
            );
          }
    
        }
      }
      print(state.checkBiometric);
    }
    catch(error){
      print(error);
    }
  }

  void setTouchID(bool value) {
    if (state.setTouchID==false) {
      state.setTouchID=true;
    }
    else state.setTouchID = false;
    state.stateChanged((){});
  }
}

  
