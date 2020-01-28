import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/view/forgetpassword.dart';
import 'package:PawPrint/view/mydialog.dart';
import 'package:flutter/material.dart';

class ForgetPasswordController{
  
  ForgetPasswordState state;
  ForgetPasswordController(this.state);

String validateEmail(String value){
  if(value == null || !value.contains('.') || !value.contains('@'))
  return 'Enter valid Email Address';
  return null; 
}


void saveEmail(String value){
  state.user.email = value;

}


//Creativity
void resetPassword() async {
  if(!state.formKey.currentState.validate()){
    return;
  }
  state.formKey.currentState.save();    
    try{   
      await MyFirebase.resetPass(
      state.user.email);
      //Show message saying reset email sent
      MyDialog.info(
        context: state.context,
        title: 'Email Sent Successfully',
        message: 'Please check your email!!!',
        action: () => Navigator.pop(state.context),
      );

    } catch(e){
        MyDialog.info(    //Display Dialog Box 
        context: state.context,
        title: 'Reset Password Failed',
        message: e.message != null ? e.message : e.toString(),
        action: () => Navigator.pop(state.context),
      );

      return;  //Do not proceed if account creation failed
  }
  }
  
}