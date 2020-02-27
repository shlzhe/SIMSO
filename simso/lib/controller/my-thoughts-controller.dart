

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../service-locator.dart';
import '../model/entities/globals.dart' as globals;
import '../model/entities/user-model.dart';
import '../model/entities/thought-model.dart';
import '../model/services/itimer-service.dart';
import '../model/services/iuser-service.dart';
import '../model/services/thought-service.dart';
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


  void getMyThoughtsList(String email) async {
    try {
       myThoughtsList = await _thoughtService.getThoughts(state.user.uid);
    } catch (e) {
       myThoughtsList = <Thought>[];
    }

    if(myThoughtsList == null || myThoughtsList.isEmpty){
      var newThought = Thought(tags: ['Welcome'],text: 'Welcome, add a new thought!', timestamp: DateTime.now(),uid: state.user.uid);
      myThoughtsList.add(newThought);
    }
    state.myThoughtsList = myThoughtsList;
    
    
  }

    

}