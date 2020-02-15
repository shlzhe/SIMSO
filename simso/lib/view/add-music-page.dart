import 'package:flutter/material.dart';
import '../controller/add-music-controller.dart';

class AddMusic extends StatefulWidget {
  AddMusic();

  @override
  State<StatefulWidget> createState() {
    return AddMusicState();
  }
}

class AddMusicState extends State<AddMusic> {
  AddMusicController controller;
  BuildContext context;

  AddMusicState() {
    controller = AddMusicController(this);
  }

  void stateChanged(Function fn) {
    setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold();
  }
}
