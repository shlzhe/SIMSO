import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/controller/mainChatPage-controller.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/navigation-drawer.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/homepage-controller.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';

class MainChatPage extends StatefulWidget {
  final UserModel user;

  MainChatPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return MainChatPageState(user);
  }
}

class MainChatPageState extends State<MainChatPage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  MainChatPageController controller;
  UserModel user;
  List<UserModel>userList;                                //To hold all SimSO users, initialized null
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  
  MainChatPageState(this.user) {
    controller = MainChatPageController(this, this.timerService, this.touchService,this.userList);
  
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
    
      appBar: AppBar(
        title: Text('SimSo Together'),
        backgroundColor: DesignConstants.blue,
      ),
      drawer: MyDrawer(context, user),
      body: new Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),   //Top center raise buttin
          child: Column(     
          children: <Widget>[  
             new RaisedButton.icon(    
             icon: Icon(Icons.public), 
            label: Text('Public'),
            textColor: DesignConstants.blue,
            onPressed: controller.showUsers, 
             ),  
          ],
      ),
        ),
      )
     
     
      
    );
}
}