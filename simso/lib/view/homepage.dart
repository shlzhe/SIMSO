import 'package:flutter/material.dart';
import 'package:simso/controller/homepage-controller.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import '../model/entities/globals.dart' as globals;
class Homepage extends StatefulWidget {
  final UserModel user;

  Homepage(this.user);

  @override
  State<StatefulWidget> createState() {
    return HomepageState(user);
  }
}

class HomepageState extends State<Homepage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  HomepageController controller;
  UserModel user;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  HomepageState(this.user) {
    controller = HomepageController(this, this.userService, this.timerService);
    controller.setupTimer();
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Form(
            key: formKey,
            child: Column(children: <Widget>[
              TextFormField(
                onSaved: controller.saveEmail,
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
              ),
              TextFormField(
                onSaved: controller.saveUsername,
                decoration: InputDecoration(
                  labelText: 'Username'
                ),
              ),
              FlatButton(
                onPressed: controller.saveUser,
                child: Text(
                  'Add Data',
                ),
              ),
              Text( returnedID == null ? '' :
                'The ID of your new document has returned', 
                style: TextStyle(color: Colors.redAccent),),
              TextFormField(
                onSaved: controller.saveUserID,
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'Get Customer by ID',
                ),
              ),
              FlatButton(
                onPressed: controller.getUserData,
                child: Text(
                  'Get User',
                ),
              ),
              Text('User Email: ' + user.email==null ? '': 'user.email'),
              Text('Username: ' + user.username==null ? '': 'user.username'),
              Text(globals.timer == null ? '' : '${globals.timer.timeOnAppSec}'),
              FlatButton(
                onPressed: controller.refreshState,
                child: Text(
                  'Resfresh State',
                ),
              ),
            ],),
        )
      ),
    );
  }
}
