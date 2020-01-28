import 'package:PawPrint/controller/forgetpassword_controller.dart';
import 'package:PawPrint/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForgetPassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    
    return ForgetPasswordState();
  }

}

class ForgetPasswordState extends State<ForgetPassword>{
  ForgetPasswordController controller;

  BuildContext context;

  //Constructor
  ForgetPasswordState(){
    controller = ForgetPasswordController(this);
  }

  void stateChanged(Function fn){
    setState(fn);
  }

  //User object
  var user = User();


  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
     this.context = context;
    return Scaffold(
      appBar: AppBar(
         title: Text('Reset Password',style: TextStyle(fontSize: 35,fontFamily: 'Modak'),),
         backgroundColor: Colors.green,
      ),
      body: Form(
         key: formKey,
      
        child: ListView(
       
        children: <Widget>[
             TextFormField(
              initialValue: user.email,
              decoration: InputDecoration(
                labelText: 'Enter email as login name',
                hintText: 'email',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
              onSaved: controller.saveEmail,
             ),
        //Creativity     
        RaisedButton(
          child: Text('Reset Password'),
              onPressed: controller.resetPassword,
        ),      
        ],
      ),
      ),

    );
  }
  
}