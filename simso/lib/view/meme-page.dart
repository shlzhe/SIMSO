import 'package:flutter/material.dart';
import '../controller/meme-page-controller.dart';

class MemePage extends StatefulWidget {
  MemePage();

  @override
  State<StatefulWidget> createState() {
    return MemePageState();
  }
}

class MemePageState extends State<MemePage> {
  MemePageController controller;
  BuildContext context;

  MemePageState() {
    controller = MemePageController(this);
  }

  void stateChanged(Function fn) {
    setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Meme Page')
      ),
      
    );
  }
}