import 'package:simso/controller/googleSignInPage_controller.dart';
import 'package:simso/view/design-constants.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import '../model/entities/globals.dart' as globals;



class GoogleSignInPage extends StatefulWidget {
  final UserModel user;
 
  GoogleSignInPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return GoogleSignInPageState(user);
  }
}

class GoogleSignInPageState extends State<GoogleSignInPage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  GoogleSignInPageController controller;
  UserModel user;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  GoogleSignInPageState(this.user) {
    controller = GoogleSignInPageController(this);

  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var childButtons = List<UnicornButton>();

    return Scaffold(
      backgroundColor: DesignConstants.blue,   //Body's background color
      appBar: AppBar(
        backgroundColor: DesignConstants.blue,
        title: Text('Google Sign In',style: TextStyle(color: DesignConstants.yellow),),
        
      ),
      body: 
       
      Container(
          child: Form(
        key: formKey,
        child: Column(
          
          children: <Widget>[

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
        
           
           //BUTTON FOR GOOGLE SIGN IN 
           FlatButton(
                onPressed: controller.googleSignIn,    //defined googleSignin() in controller
                //icon:Icon(Icons.email,color: DesignConstants.yellow),
                child:Text('Google Sign In', style: TextStyle(color: DesignConstants.yellow),),
            
           ),
            
          ],
        ),
      )),
    );
  }
}

