import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/login-page-controller.dart';
import 'package:simso/view/design-constants.dart';

import '../model/entities/user-model.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  BuildContext context;
  LoginPageController controller;
  UserModel user;
  bool entry = false;
  var formKey = GlobalKey<FormState>();
  LoginPageState() {
    controller = LoginPageController(this);
    user = UserModel.isEmpty();
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Container(
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  CachedNetworkImage(imageUrl: DesignConstants.logo),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter email as login name: a@uco.edu',
                      hintText: 'email',
                      hintStyle: TextStyle(color: DesignConstants.yellow),
                      labelStyle: TextStyle(color: DesignConstants.yellow),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.validateEmail,
                    onSaved: controller.saveEmail,
                    style: TextStyle(color: DesignConstants.yellow),
                    onChanged: controller.entry,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter password: 123456',
                      hintText: 'password',
                      hintStyle: TextStyle(color: DesignConstants.yellow),
                      labelStyle: TextStyle(color: DesignConstants.yellow),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: controller.validatePassword,
                    onSaved: controller.savePassword,
                    style: TextStyle(color: DesignConstants.yellow),
                  ),
                  entry == true
                      ? FlatButton(
                          onPressed: controller.goToHomepage,
                          child: Text(
                            'Login',
                          ),
                          textColor: DesignConstants.yellow,
                          color: DesignConstants.blueLight,
                        )
                      : FlatButton(
                          onPressed: controller.createAccount,
                          child: Text(
                            'Create Account',
                          ),
                          textColor: DesignConstants.yellow,
                          color: DesignConstants.blueLight,
                        ),
                ],
              ),
            ],
          ),
        ),
        color: DesignConstants.blue,
      ),
    );
  }
}
