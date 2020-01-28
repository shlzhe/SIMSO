
import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/user.dart';
import 'package:PawPrint/view/forgetpassword.dart';
import 'package:PawPrint/view/frontpage.dart';
import 'package:PawPrint/view/homepage.dart';
import 'package:PawPrint/view/mydialog.dart';
import 'package:PawPrint/view/signuppage.dart';
import 'package:flutter/material.dart';

class FrontPageController{
  FrontPageState state;
  FrontPageController(this.state);


void createAccount(){
  Navigator.push(state.context,MaterialPageRoute(
    builder: (context) => SignUpPage(),
  ));
}


String validateEmail(String value){
  if(value == null || !value.contains('.') || !value.contains('@')){
    return 'Enter valid Email Address';
  }
  return null;
}

void saveEmail(String value){
  state.user.email = value;
}


String validatePassword(String value){
  if(value.length < 6 || value == null){
    return 'Enter valid password';
  }
  return null;
}

void savePassword(String value){
  state.user.password = value;
}

void login() async {
  if(!state.formKey.currentState.validate()){
    return;
  }
  state.formKey.currentState.save();

  //Show Progress Bar animation
  MyDialog.showProgressBar(state.context);


  try{
    state.user.uid = await MyFirebase.login(
      email:state.user.email, 
      password: state.user.password);
     

    } catch (e){  
      //If error occurrs show error message
      //Dispose Progress Bar and show dialog box 
      MyDialog.popProgressBar(state.context);
      MyDialog.info(
        
        context: state.context,
        title: 'Login Error',
        message: e.message != null ? e.message: e.toString(),
        action: () => Navigator.pop(state.context),
      );
        return;  //Do not proceed if log in failed
    }
     try{
       User user = await MyFirebase.readProfile(state.user.uid);
       if (user.level != 'disabled'){
          state.user.displayName = user.displayName;
          state.user.zip = user.zip;
          state.user.profilePic = user.profilePic;
          state.user.street = user.street;
          state.user.city = user.city;
          state.user.state = user.state;
          state.user.numOfPets = user.numOfPets;
          state.user.level = user.level;
          state.user.searchAdd = '${user.street}, ${user.city}, ${user.state}, ${user.zip}';
          state.user.boardingRate = user.boardingRate;
          state.user.walkingRate = user.walkingRate;
          state.user.dayCare = user.dayCare;
          state.user.dropInVisit = user.dropInVisit;
          state.user.houseSitting = user.houseSitting;
          }
          if (user.level =='disabled') {
            throw('~~~~~~~~~~~Account is disabled.~~~~~~~~~~~~~');
          }
      }catch(e){   //If error occurs
            //No display name and zip passed
            print ('********READPROFILE' + e.toString());
            MyFirebase.signOut();
     }
    List<Pet> petList;
    try{
      petList = await MyFirebase.getPetList(state.user.email);
    }catch(error){
      petList = <Pet>[];
    }
     //Navigate to user HOmePage 
      //Dispose Progress Bar before showing Success Log In Dialog Box
      MyDialog.popProgressBar(state.context);
        if (state.user.level == 'disabled'){
        MyDialog.info(
          context: state.context,
          title: 'Login Failed',
          message: 'Account disabled',
          action: (){
            Navigator.pop(state.context);     //Dispose dialog box
            // Navigator.pop(state.context);
          }        
        );
        return;
      }
      else{
         MyDialog.info(
        context: state.context,
        title: 'Login Success',
        message: 'Press <OK> to Navigate to User Home Page',
        action: (){
          Navigator.pop(state.context);     //Dispose dialog box
          Navigator.push(state.context,MaterialPageRoute(   //Move to HomePage
          builder: (context) => HomePage(state.user, petList),
        ));   //Navigate to UserHomePage
        }        
      );
      }
  }


   //Creativity
  void forgetPassword(){
    print('Forget Password clicked');

    //Navigate to Forget Password Page
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => ForgetPassword(),
    ));
  }
}



