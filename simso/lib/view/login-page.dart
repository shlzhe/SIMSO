import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/login-page-controller.dart';
import 'package:simso/view/design-constants.dart';
import '../model/entities/user-model.dart';
import 'package:simso/model/entities/local-user.dart';

class LoginPage extends StatefulWidget {
  final LocalUser localUserFunction;
  final email;
  final password;
  final credential;
  LoginPage({Key key, @required this.localUserFunction, this.email, this.password, this.credential, }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return LoginPageState(localUserFunction,email, password, credential);
  }
}

class LoginPageState extends State<LoginPage> {
  String email;
  String password;
  String credential;
  String readInData;
  BuildContext context;
  LoginPageController controller;
  VideoPlayerController controller1;
  UserModel user;
  LocalUser localUserFunction;
  LocalAuthentication bioAuth = LocalAuthentication();
  bool checkBiometric = false;
  bool setTouchID = false;
  bool setCredential = false;
  String authBio = "Not Authorized";
  List<BiometricType> biometricList = List<BiometricType>();
  IUserService userService = locator<IUserService>();
  bool entry = false;
  var formKey = GlobalKey<FormState>();
  LoginPageState(this.localUserFunction, this.email, this.password, this.credential) {
    controller = LoginPageController(this, this.userService);
    user = UserModel.isEmpty();
    credential == 'true'? setCredential = true : setCredential = false;
  }

  void stateChanged(Function f) {
    setState(f);
  }

  void writeCredential(){
    var data = 'true';
    widget.localUserFunction.writeCredential(data);
  }

  void writeLocalUser(UserModel localuser){
    var data = localuser.email+" "+localuser.password;
    widget.localUserFunction.writeLocalUser(data);
  }

  //----------------------------------------------------
  //CREATE INSTANCES FOR GOOGLE SIGN IN 
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //----------------------------------------------------

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
                        Image.network(
                          DesignConstants.logo,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                initialValue: credential=='true'? email:null,
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
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: TextFormField(
                            initialValue: credential=='true'?password:null,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text('Remember me', style: TextStyle(color: DesignConstants.yellow),),
                                      Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: DesignConstants.blueLight,
                                        ),
                                        child: Checkbox(
                                          onChanged: controller.setCredential,
                                          value: setCredential,
                                          checkColor: DesignConstants.red,
                                        ),
                                      ),
                                    ],
                                  ),
                            (entry == true || credential =='true')
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Set TouchID after Login', style: TextStyle(color: DesignConstants.yellow),),
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: DesignConstants.blueLight,
                                ),
                                child: Checkbox(
                                  onChanged: controller.setTouchID, 
                                  value: setTouchID,
                                  checkColor: DesignConstants.red,
                                ),
                              ),
                              IconButton(
                                onPressed: controller.loginBiometric,
                                icon: Image.network('https://firebasestorage.googleapis.com/v0/b/capstone-16d44.appspot.com/o/ApplicationImages%2Ffingerprint.png.jpg?alt=media&token=88b15f2e-269c-484b-9a43-1690f067180e'),
                                color: DesignConstants.yellow,
                              ),
                            ],
                          ),
                               //----------------------------------------------------
                          //GOOGLE SIGN IN BUTTON
                          OutlineButton(
                            onPressed: controller.googleSignIn,
                            splashColor: Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            highlightElevation: 0,
                            borderSide: BorderSide(color: DesignConstants.yellow),
                            child: Padding(padding:const EdgeInsets.fromLTRB(0, 5, 0, 5), 
                              child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        CachedNetworkImage(imageUrl: DesignConstants.google_logo, height: 15.0),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text('Google sign-in',style:TextStyle(color:DesignConstants.yellow,fontSize: 15),
                                          )
                                        )
                                      ],

                              )
                            ),
                            ), 
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
