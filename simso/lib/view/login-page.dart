import 'package:flutter/material.dart';
import 'package:simso/controller/login-page-controller.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  BuildContext _context;
  IUserService _userService = locator<IUserService>();
  LoginPageController _controller;
  UserModel user = UserModel();
  var formKey = GlobalKey<FormState>();

  LoginPageState() {
    _controller = LoginPageController(this, this._userService);
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(children: <Widget>[
          Text('Click the button to retrieve the user data.'),
          RaisedButton(
            child: Text('Get Data'),
            onPressed: _controller.getUserData,
          ),
          Text('Username: ${user.username}'),
          Text('Email: ${user.email}'),
          RaisedButton(
            child: Text('Add User'),
            onPressed: _controller.saveUser,
          ),
        ],),
      ),
    );
  }
}
