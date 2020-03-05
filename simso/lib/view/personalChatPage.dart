import 'package:cached_network_image/cached_network_image.dart';
import 'package:simso/controller/mainChatPage-controller.dart';
import 'package:simso/controller/personalChatPage-controller.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/navigation-drawer.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';

class PersonalChatPage extends StatefulWidget {
  final UserModel user;
  int index; //index of selected Simso
  List<UserModel>userList;
  PersonalChatPage(this.user, this.index,this.userList);        //Receive data from mainChatPage controller
  
  @override
  State<StatefulWidget> createState() {
    return PersonalChatPageState(user, index,userList);
  }
}

class PersonalChatPageState extends State<PersonalChatPage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  PersonalChatPageController controller;
  UserModel user;
  int index;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool publicFlag = false;
  List<UserModel>userList;
  PersonalChatPageState(this.user,this.index,this.userList) {
    controller = PersonalChatPageController(this);
  
  }
  
  void stateChanged(Function f) {
    setState(f);
  }
 
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
    
      appBar: AppBar(
        centerTitle: true,
        title: Text('${userList[index].username} '),
        
        backgroundColor: DesignConstants.blue,
      ),
      drawer: MyDrawer(context, user),
      body: Text('Personal Chat Screen with SimSo index $index'),
     
     
      
    );
}
}