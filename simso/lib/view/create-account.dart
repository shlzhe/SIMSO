import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/create-account-controller.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/design-constants.dart';

class CreateAccount extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CreateAccountState();
      }
    
    }
    
    class CreateAccountState extends State<CreateAccount> {
      CreateAccountController controller;
      BuildContext context;
      var formKey = GlobalKey<FormState>();
      UserModel user;
      CreateAccountState(){
        controller = CreateAccountController(this);
        user = UserModel.isEmpty();
      }
      void stateChanged(Function f) {
        setState(f);
      }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: Form(
        key: formKey,
              child: ListView(
          children: <Widget>[
            Image.network(DesignConstants.logo),
            TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter email as login name:' ,
                      hintText: 'email',
                      hintStyle: TextStyle(color: DesignConstants.yellow),
                      labelStyle: TextStyle(color: DesignConstants.yellow),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.validateEmail,
                    onSaved: controller.saveEmail,
                    style: TextStyle(color: DesignConstants.yellow),
                  ),
            TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter password:',
                    hintText: 'create a password',
                    hintStyle: TextStyle(color: DesignConstants.yellow),
                    labelStyle: TextStyle(color: DesignConstants.yellow),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: controller.validatePassword,
                  onSaved: controller.savePassword,
                  style: TextStyle(color: DesignConstants.yellow),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'choose a username',
                    hintStyle: TextStyle(color: DesignConstants.yellow),
                    labelStyle: TextStyle(color: DesignConstants.yellow),
                  ),
                  onSaved: controller.saveUsername,
                  style: TextStyle(color: DesignConstants.yellow),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'About Me',
                    hintText: 'talk about yourself',
                    hintStyle: TextStyle(color: DesignConstants.yellow),
                    labelStyle: TextStyle(color: DesignConstants.yellow),
                  ),
                  maxLines: 5,
                  onSaved: controller.saveAboutMe,
                  style: TextStyle(color: DesignConstants.yellow),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'Which city?',
                    hintStyle: TextStyle(color: DesignConstants.yellow),
                    labelStyle: TextStyle(color: DesignConstants.yellow),
                  ),
                  onSaved: controller.saveCity,
                  style: TextStyle(color: DesignConstants.yellow),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Relationship Status',
                    hintText: 'single, married, divorce, etc.',
                    hintStyle: TextStyle(color: DesignConstants.yellow),
                    labelStyle: TextStyle(color: DesignConstants.yellow),
                  ),
                  onSaved: controller.saveRelationship,
                  style: TextStyle(color: DesignConstants.yellow),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Memo',
                    hintText: 'Memo space',
                    hintStyle: TextStyle(color: DesignConstants.yellow),
                    labelStyle: TextStyle(color: DesignConstants.yellow),
                  ),
                  maxLines: 3,
                  onSaved: controller.saveMemo,
                  style: TextStyle(color: DesignConstants.yellow),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Favorites',
                    hintText: '',
                    hintStyle: TextStyle(color: DesignConstants.yellow),
                    labelStyle: TextStyle(color: DesignConstants.yellow),
                  ),
                  maxLines: 3,
                  onSaved: controller.saveFavorite,
                  style: TextStyle(color: DesignConstants.yellow),
                ),
                RaisedButton(
                  onPressed: controller.createCancel,
                  child: Text(
                    'Cancel',
                  ),
                  textColor: DesignConstants.yellow,
                  color: DesignConstants.blueLight,
                ),
          ],
        ),
      ),
      backgroundColor: DesignConstants.blue,
      bottomNavigationBar: FlatButton(
                  onPressed: controller.createAccount,
                  child: Text(
                    'Create Account',
                  ),
                  textColor: DesignConstants.yellow,
                  color: DesignConstants.blueLight,
                ),
    );
  }

}