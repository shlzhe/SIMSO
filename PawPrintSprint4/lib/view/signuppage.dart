import 'package:PawPrint/controller/signuppage_controller.dart';
import 'package:PawPrint/model/user.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget{
 

  @override
  State<StatefulWidget> createState() {
    
    return SignUpPageState();
  }

}

class SignUpPageState extends State<SignUpPage>{
  
  SignUpPageController controller;
  BuildContext context;
  var formKey = GlobalKey<FormState>();
  User user = User();
  bool chk = false;
  void stateChanged (Function fn){
    setState(fn);
  }

  //Constructor
  SignUpPageState(){
    controller = SignUpPageController(this);
  }
  @override

  Widget build(BuildContext context) {
    this.context = context;  
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',style: TextStyle(fontSize: 35,fontFamily: 'Modak'),),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key:formKey,
        child: ListView(
          children: <Widget>[
//Profile Picture textformfield removed... upload in profile.
            TextFormField(
              initialValue: user.email,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Email (as login name)',
                labelText: 'Email',
              ),
              validator: controller.validateEmail,
              onSaved: controller.saveEmail,
            ),
            TextFormField(
              initialValue: user.password,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
              ),
              validator: controller.validatePassword,
              onSaved: controller.savePassword,
            ),
            TextFormField(
              initialValue: user.displayName,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Display name',
                labelText: 'Display name',
              ),
              validator: controller.validateDisplayName,
              onSaved: controller.saveDisplayName,
            ),
            
            //Home street 
             TextFormField(
              
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Home street',
                labelText: 'Home street',
              ),
              validator: controller.validateDisplayName,
              onSaved: controller.saveStreet,
            ),

              //State
             TextFormField(
              
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'State',
                labelText: 'State',
              ),
              validator: controller.validateDisplayName,
              onSaved: controller.saveState,
            ),

              //State
             TextFormField(
              
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'City',
                labelText: 'City',
              ),
              validator: controller.validateDisplayName,
              onSaved: controller.saveCity,
            ),


            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Zip code',
                labelText: 'Zip code',
              ),
              validator: controller.validateZip,
              onSaved: controller.saveZip,
            ),
            
            Column(
              children: <Widget>[
                Text('Check to be a Provider'),
                Checkbox(
                  value: chk,
                  onChanged: controller.addprovider,
                ),
              ],
            ),

            RaisedButton(
              child: Text('Create Account'),
              onPressed: controller.createAccount,
            )
          ],
        ),
      ),
    );
  }

}