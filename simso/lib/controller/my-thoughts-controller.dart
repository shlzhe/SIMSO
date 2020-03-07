

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../service-locator.dart';
import '../model/entities/globals.dart' as globals;
import '../model/entities/user-model.dart';
import '../model/entities/thought-model.dart';
import '../model/services/ithought-service.dart';

import '../view/mydialog.dart';
import '../view/homepage.dart';
import '../view/my-thoughts-page.dart';
import '../view/add-thought-page.dart';


class MyThoughtsController{

  MyThoughtsPageState state;
  UserModel newUser = UserModel();
  String userID;
  List<Thought> myThoughtsList;
  IThoughtService _thoughtService = locator<IThoughtService>();

  MyThoughtsController(this.state);

  void addThought() {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddThoughtPage(state.user),
        ));
  }


    

}