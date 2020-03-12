import 'package:simso/model/entities/local-user.dart';
import 'package:simso/service-locator.dart';
import './view/login-page.dart';
import 'package:flutter/material.dart';

import 'controller/lifecycle_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String email;
  String password;
  String credential;
  LocalUser localUserFunction = LocalUser();
  try{
    var inFile = await localUserFunction.readLocalUser();
    int i = inFile.indexOf(' ');
    email = inFile.substring(0,i);
    password= inFile.substring(i+1);
  }catch(error){}
  try{
    credential= await localUserFunction.readCredential();
  }catch(error){}
  setupServiceLocator();
  runApp(SimsoApp(localUserFunction, email,password, credential));
}
class SimsoApp extends StatelessWidget {
  final email;
  final password;
  final credential;
  final localUserFunction;
  SimsoApp(this.localUserFunction, this.email, this.password, this.credential);
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: MaterialApp(
        home: LoginPage(
          localUserFunction: localUserFunction,
          email: email,
          password: password,
          credential: credential,
          ),
      )
    );
  }

}