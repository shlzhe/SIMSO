import 'package:cached_network_image/cached_network_image.dart';
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
  String url =
      'https://firebasestorage.googleapis.com/v0/b/capstone-16d44.appspot.com/o/ApplicationImages%2FSimSoLogo.png?alt=media&token=9285c534-aca6-4833-ab47-40bbd8dee518';
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
                CachedNetworkImage(imageUrl: url),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter email as login name: a@uco.edu',
                    hintText: 'email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  onSaved: controller.saveEmail,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter password: 123456',
                    hintText: 'password',
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: controller.validatePassword,
                  onSaved: controller.savePassword,
                ),
                RaisedButton(
                  onPressed: controller.goToHomepage,
                  child: Text(
                    'Login',
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
