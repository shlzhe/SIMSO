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
  String returnedID;
  var idController = TextEditingController();
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
        child: Form(
            key: formKey,
            child: Column(children: <Widget>[
              TextFormField(
                onSaved: _controller.saveEmail,
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
              ),
              TextFormField(
                onSaved: _controller.saveUsername,
                decoration: InputDecoration(
                  labelText: 'Username'
                ),
              ),
              FlatButton(
                onPressed: _controller.saveUser,
                child: Text(
                  'Add Data',
                ),
              ),
              Text( returnedID == null ? '' :
                'The ID of your new document has returned', 
                style: TextStyle(color: Colors.redAccent),),
              TextFormField(
                onSaved: _controller.saveUserID,
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'Get Customer by ID',
                ),
              ),
              FlatButton(
                onPressed: _controller.getUserData,
                child: Text(
                  'Get User',
                ),
              ),
              Text('User Email: ${user.email}'),
              Text('Username: ${user.username}'),
            ],),
        )
      ),
    );
  }
}
