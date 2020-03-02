import 'package:simso/controller/main-screen-page-controller.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/navigation-drawer.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';

class MainScreenPage extends StatefulWidget {
  final UserModel user;

  MainScreenPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return MainScreenPageState(user);
  }
}

class MainScreenPageState extends State<MainScreenPage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  MainScreenPageController controller;
  UserModel user;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  //Constructor
  MainScreenPageState(this.user) {
    controller = MainScreenPageController(this);
   
  }

    
  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Messenger'),
        backgroundColor: DesignConstants.blue,
        
      ),

      //DISPLAY ALL FRIENDS IN DB 
      //----------------------------------------


      //----------------------------------------
    
      drawer: MyDrawer(context, user),
      body: Container(
          child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
          ],
        ),
      ),),
    );
  }
}
