import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/model/user.dart';
import 'package:PawPrint/view/mydialog.dart';
import 'package:PawPrint/view/signuppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class SignUpPageController{
  SignUpPageState state;
  SignUpPageController(this.state);


String validateEmail(String value){
  if(value == null || !value.contains('.')|| !value.contains('@')){
    return 'Enter valid Email address';
     }
  return null;
   }

 void saveEmail(String value){
   state.user.email = value;   
 }

 String validatePassword(String value){
   if(value == null){
     return 'Enter password';
   }
   return null;
 }

 void savePassword(String value){
   state.user.password = value;
 }

String validateDisplayName(String value){
   if(value == null || value.length <2){
     return 'Enter at least 2 characters';
   }
   return null;
 }

void saveDisplayName(String value){
  state.user.displayName = value;
}

String validateZip(String value){
  if(value == null || value.length <5 ){
    return 'Entern at least 5-digit code';
  }
  try{
    int n = int.parse(value);
    if(n<10000){
      return 'Enter 5-digit ZIP code';
    }
  }catch(e){
    return 'Enter 5-digit ZIP code';
  }
  return null;
}

void saveZip(String value){
  state.user.zip = int.parse(value);
}

void createAccount() async {
  if(!state.formKey.currentState.validate()){
    return;
  }
    state.formKey.currentState.save();

    //Try catch to avoid duplicate registration
    try{
    //Using email/password: sign up an account at Firebase
    state.user.uid = await MyFirebase.createAccount(
      email: state.user.email, 
      password: state.user.password,
      //profilePic: state.user.profilePic,
      );

    } catch(e){
      MyDialog.info(    //Display Dialog Box 
        context: state.context,
        title: 'Account creation failed',
        message: e.message != null ? e.message : e.toString(),
        action: () => Navigator.pop(state.context),
        
      );
       
      return;  //Do not proceed if account creation failed
      
    }


    //Create user profile in Firestore database
    try{
      var address = await Geocoder.local.findAddressesFromQuery(state.user.street +','+ state.user.city +','+ state.user.state +','+ state.user.zip.toString());
       var first = address.first;
       print("${first.featureName}: ${first.coordinates} in frontPage_controller");
        
       state.user.lati = first.coordinates.latitude.toString();
       state.user.longti = first.coordinates.longitude.toString();

       // Update coordinates in Firestore
       //FIRST, find the docID of the user
       try{
                  QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILE_COLLECTION).
         where('email', isEqualTo: state.user.email).getDocuments();
         
         if(querySnapshot==null || querySnapshot.documents.length == 0){
           print('no docID found');
         }
        for(DocumentSnapshot doc in querySnapshot.documents){
        print('Selected docID: ${doc.documentID}');
                print('Selected docID: ${doc.documentID}');
        
        //UPDATE COORDINATES IN FIRESTORE EVEYTIME THE USER LOG IN
        await Firestore.instance.collection('userprofile')
        .document(doc.documentID).updateData({
          'lati': state.user.lati,
          'longti': state.user.longti, 
          'street': state.user.street,
          'city': state.user.city,
          'state': state.user.state,
          'zip': state.user.zip,
          'displayName': state.user.displayName,
          });        
        }
       }
       catch(e){
         throw e;}

        //---------
        //AFTER UPDATE LATI AND LONGTI IN USERPROFILE
    //NOW SET LATI AND LONGTI IN PROVIDERLIST
    //---------------------------------------------
       try{
         QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILELIST_COLLECTION).
         where('email', isEqualTo: state.user.email).getDocuments();
         
         if(querySnapshot==null || querySnapshot.documents.length == 0){
           print('no docID found');
         }
         for(DocumentSnapshot doc in querySnapshot.documents){
        print('Selected provider in providerlist: ${doc.documentID}');
        
        //UPDATE COORDINATES IN FIRESTORE EVEYTIME THE USER LOG IN
        await Firestore.instance.collection('providerlist')
        .document(doc.documentID).updateData({
          'lati': state.user.lati,
          'longti': state.user.longti,
          'street': state.user.street,
          'city': state.user.city,
          'state': state.user.state,
          'zip': state.user.zip,
          'displayName': state.user.displayName
          });

 
               }
            
       }
       catch(e){
         throw e;}
      MyFirebase.createProfile(state.user);   //Create document in User Profile
      if (state.chk) MyFirebase.createProviderList(state.user);
    } catch (e){
      state.user.displayName = null;
      state.user.zip = null;
      state.user.profilePic = null;
    }

      MyDialog.info(
        context: state.context,
        title: 'Account created successfully!!!',
        message: 'Your account is created with ${state.user.email}',
        action: () => {Navigator.pop(state.context),
        Navigator.pop(state.context), //Return to frontpage 
        }
      );
       
  }
  
 

 
  void saveStreet(String newValue) {
    state.user.street = newValue;
  }

  void saveState(String newValue) {
    state.user.state = newValue;
  }

  void saveCity(String newValue) {
    state.user.city = newValue;
  }

  void addprovider(bool value) {
    state.stateChanged((){
      state.chk = value;
    });
    if (value==true) state.user.level ='provider';
    else state.user.level = 'user';
  }
}
