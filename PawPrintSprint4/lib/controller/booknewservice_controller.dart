
import 'package:PawPrint/view/booknewservice.dart';
import 'package:PawPrint/view/service.dart';
import 'package:flutter/material.dart';


class BookNewServiceController{
  BookNewServiceState state;
  BookNewServiceController(this.state);

  
  onTap(int index) {

    Navigator.push(state.context, MaterialPageRoute(
      builder: (context)=> Service(state.user, state.userList[index], state.petList),
    ));
  }

  onLongPress(int index) {}
}