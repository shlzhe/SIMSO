import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/entities/user-model.dart';
import '../model/entities/thought-model.dart';
import '../view/design-constants.dart';
import '../controller/my-thoughts-controller.dart';
import '../model/entities/globals.dart' as globals;

class MyThoughtsPage extends StatefulWidget {
  final UserModel user;
  final List<Thought> myThoughtsList;

  MyThoughtsPage(this.user, this.myThoughtsList);

  @override
  State<StatefulWidget> createState() {
    return MyThoughtsPageState(user, myThoughtsList);
  }
}

class MyThoughtsPageState extends State<MyThoughtsPage> {
  BuildContext context;
  MyThoughtsController controller;

  UserModel user;
  List<Thought> myThoughtsList;
  
  var formKey = GlobalKey<FormState>();

  MyThoughtsPageState(this.user, this.myThoughtsList) {
    controller = MyThoughtsController(this);

    
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    globals.context = context;
  



    return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Thoughts',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 30.0,
                color: DesignConstants.yellow),
          ),
          backgroundColor: DesignConstants.blue,
        ),
        
        body: Container(
          color: DesignConstants.blueGreyish,
          child: ListView.builder(
            itemCount: myThoughtsList == null ? 0 : myThoughtsList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: DesignConstants.blue,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    title: Text(DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
                        .format(myThoughtsList[index].timestamp)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(myThoughtsList[index].text),
                      ],
                    ),
                    onTap: () => controller.onTapThought(myThoughtsList, index),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
