import 'package:PawPrint/controller/frontpage_controller.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/user.dart';
import 'package:flutter/material.dart';

class FrontPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   
    return FrontPageState();
  }

}

class FrontPageState extends State<FrontPage>{
  FrontPageController controller;

  BuildContext context;

  //Constructor
  FrontPageState(){
    controller = FrontPageController(this);
  }

  void stateChanged(Function fn){
    setState(fn);
  }

  //User object
  var user = User();
  var pet = Pet();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('PawPrint',style: TextStyle(fontSize: 45,fontFamily: 'Modak'),),
        backgroundColor: Colors.green,    //app bar background color
        centerTitle: true,                //center title
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

            TextFormField(
              initialValue: user.password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter password',
                hintText: 'password',
                
              ),
              validator: controller.validatePassword,
              onSaved: controller.savePassword,
            ),

            //LOG IN BUTTON
            RaisedButton(          
              child: Text('Log In',style: TextStyle(fontSize: 20,fontFamily: 'Modak'),),
              onPressed: controller.login,
            ),

            RaisedButton(
              child: Text('Forget Password',style: TextStyle(fontSize: 20,fontFamily: 'Modak'),),
              onPressed: controller.forgetPassword,
            ),

             RaisedButton(
              child: Text('Create Account',style: TextStyle(fontSize: 20,fontFamily: 'Modak'),),
              onPressed: controller.createAccount,
            ),
            Image.network('https://firebasestorage.googleapis.com/v0/b/pawprintmatermproj.appspot.com/o/PawPrintImages%2Fweloveyourpets.jpg?alt=media&token=c28c090e-2e81-433e-bbcb-4afa3685ead6'),
          ],
        ),
      )
    );
  }

}