import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/create-account-controller.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
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
      IUserService userService = locator<IUserService>();
      var formKey = GlobalKey<FormState>();
      UserModel user;
      CreateAccountState(){
        controller = CreateAccountController(this, this.userService);
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
                  obscureText: true,
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