import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/forget-password-controller.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
import 'package:simso/view/design-constants.dart';
import '../model/entities/globals.dart' as globals;

class ForgetPassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ForgetPasswordState();
      }
      
    }
    
    class ForgetPasswordState extends State<ForgetPassword>{
      BuildContext context;
      GlobalKey formkey;
      String email;
      String msg='';
      int q1=0, q2=0;
      String a1, a2;
      String password='';
      List<dynamic> questions = [];
      List<dynamic> answers = [];
      bool displayQuestions=false;
      ForgetPasswordController controller;
      IUserService userService = locator<IUserService>();
      ForgetPasswordState(){
        controller = ForgetPasswordController(this, this.userService);
      }
      var formKey = GlobalKey<FormState>();

      stateChanged(Function f){
        setState(f);
      }
      
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: Form(
        key: formKey,
              child: 
              //  displayQuestions ? ListView(
              //   children: <Widget>[
              //     TextFormField(
              //       decoration: InputDecoration(
              //         labelText: questions[q1] ,
              //         hintStyle: TextStyle(color: DesignConstants.yellow),
              //         labelStyle: TextStyle(color: DesignConstants.yellow),
              //       ),
              //       keyboardType: TextInputType.emailAddress,
              //       onSaved: controller.saveA1,
              //       style: TextStyle(color: DesignConstants.yellow),
              //     ),
              //     TextFormField(
              //       decoration: InputDecoration(
              //         labelText: questions[q2] ,
              //         hintStyle: TextStyle(color: DesignConstants.yellow),
              //         labelStyle: TextStyle(color: DesignConstants.yellow),
              //       ),
              //       keyboardType: TextInputType.emailAddress,
              //       onSaved: controller.saveA2,
              //       style: TextStyle(color: DesignConstants.yellow),
              //     ),
              //     RaisedButton(
              //       child: Text('Reset', style: TextStyle(color: DesignConstants.yellow),),
              //       color: DesignConstants.blue,
              //       onPressed: controller.resetWithQA,),
              //     Text(msg, style: TextStyle(color: DesignConstants.red),),
              //   ],
              // )
              // :
              ListView(
          children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter Email:' ,
                      hintText: 'email',
                      hintStyle: TextStyle(color: DesignConstants.yellow),
                      labelStyle: TextStyle(color: DesignConstants.yellow),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.validateEmail,
                    onSaved: controller.saveEmail,
                    style: TextStyle(color: DesignConstants.yellow),
                  ),
                  RaisedButton(
                    textColor: DesignConstants.yellow,
                    color: DesignConstants.blue,
                    child: Text('Reset'),
                    onPressed: controller.checkEmail,
                  ),
                  // RaisedButton(
                  //   textColor: DesignConstants.yellow,
                  //   color: DesignConstants.blue,
                  //   child: Text('Answer Questions'),
                  //   onPressed: controller.answerQuestions,
                  // ),
          ],
        )
      ),
      backgroundColor: DesignConstants.blue,
    );
  }
}