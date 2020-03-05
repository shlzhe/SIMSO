import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:simso/model/entities/local-user.dart';
import 'package:simso/service-locator.dart';
import './view/login-page.dart';
import 'package:flutter/material.dart';

import 'controller/lifecycle_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var localUser;
  //readLocalUser reads in files from android;
  // readLocalUser(localUser).then((value) => localUser = value);
  setupServiceLocator();
  //need to get non-null values from readLocalUser();
  print(localUser);
  runApp(SimsoApp(localUser));
}
Future<String> readLocalUser(localUser)async{
  var directory = await getApplicationDocumentsDirectory();
  var path = directory.path;
  var contents;
  contents = File('$path/user.txt').readAsString();
  return contents;
  }
class SimsoApp extends StatelessWidget {
  final String localUser;
  SimsoApp(this.localUser);
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      child: MaterialApp(
        home: LoginPage(localUserFunction: LocalUser(),),
      )
    );
  }

}