import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/login-page-controller.dart';
import 'package:simso/view/design-constants.dart';

//Import Google Sign In library
import 'package:google_sign_in/google_sign_in.dart';

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
  //----------------------------------------------------
  //CREATE INSTANCES FOR GOOGLE SIGN IN 
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //----------------------------------------------------
  @override
  void initState() {
    super.initState();
    controller1 = VideoPlayerController.asset("assets/videos/sparkling.mov")
      ..initialize().then((_) {
        controller1.play();
        controller1.setLooping(true);
        controller1.setVolume(0.0);
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * .6,
                // child: AspectRatio(
                //   aspectRatio: 2 / 2,
                child: VideoPlayer(controller1),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 355),
              child: Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        //CachedNetworkImage(imageUrl: DesignConstants.logo),
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
                           
                          //----------------------------------------------------
                          //GOOGLE SIGN IN BUTTON
                          OutlineButton(
                            onPressed: controller.googleSignIn,
                            splashColor: Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            highlightElevation: 0,
                            borderSide: BorderSide(color: DesignConstants.blue),
                            child: Padding(padding:const EdgeInsets.fromLTRB(0, 10, 0, 10), 
                              child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image(image:AssetImage("assets/images/google_logo.png"), height: 35.0),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text('Sign In with Google Account',style:TextStyle(color:DesignConstants.yellow,fontSize: 15),
                                          )
                                        )
                                      ],

                              )
                            ),
                            ) 
                            //----------------------------------------------------
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
