import 'package:flutter/material.dart';
import 'package:simso/controller/login-page-controller.dart';

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
      appBar: AppBar(
        title: Text('Login'),
      ),
      body:  Container(
        child: Form(
            key: formKey,
            child: Column(children: <Widget>[
              TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter email as login name',
                hintText: 'email',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
              onSaved: controller.saveEmail,
              ),
              RaisedButton(
                onPressed: controller.goToHomepage,
                child: Text(
                  'Dont enter email. Go to Homepage',
                ),
              ),
            ],
            ),
        )
      ),
    );
  }
}
