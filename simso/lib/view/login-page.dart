import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
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
  VideoPlayerController controller1;
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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: DesignConstants.blue,
        body: Stack(
          children: <Widget>[
            Container(
              child: Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CachedNetworkImage(imageUrl: DesignConstants.logo),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: DesignConstants.yellow),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: DesignConstants.yellow),
                              ),
                              labelText: 'Email',
                              hintText: 'email',
                              hintStyle: TextStyle(
                                  color: DesignConstants.yellow, fontSize: 10),
                              labelStyle: TextStyle(
                                  color: DesignConstants.yellow, fontSize: 20),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: controller.validateEmail,
                            onSaved: controller.saveEmail,
                            style: TextStyle(color: DesignConstants.yellow),
                            onChanged: controller.entry,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: DesignConstants.yellow),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: DesignConstants.yellow),
                              ),
                              labelText: 'Password',
                              hintText: 'password',
                              hintStyle: TextStyle(
                                  color: DesignConstants.yellow, fontSize: 10),
                              labelStyle: TextStyle(
                                  color: DesignConstants.yellow, fontSize: 20),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            validator: controller.validatePassword,
                            onSaved: controller.savePassword,
                            style: TextStyle(color: DesignConstants.yellow),
                          ),
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
              //color: DesignConstants.blue,
            ),
          ],
        ),
      ),
      //color: DesignConstants.blue,
    );
  }
}
