import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/entities/thought-model.dart';
import '../model/entities/user-model.dart';
import '../view/design-constants.dart';
import '../controller/visit-thoughts-controller.dart';
import '../model/entities/globals.dart' as globals;

class VisitThoughtsPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel visitUser;
  List<Thought> visitThoughtsList;

  VisitThoughtsPage(this.currentUser, this.visitUser,this.visitThoughtsList);

  @override
  State<StatefulWidget> createState() {
    return VisitThoughtsPageState(currentUser, visitUser, visitThoughtsList);
  }
}

class VisitThoughtsPageState extends State<VisitThoughtsPage> {
  BuildContext context;
  VisitThoughtsController controller;
    UserModel currentUser;
  UserModel visitUser;


  List<Thought> visitThoughtsList;
    var formKey = GlobalKey<FormState>();

  VisitThoughtsPageState(this.currentUser, this.visitUser, this.visitThoughtsList) {
    controller = VisitThoughtsController(this);

    
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
            visitUser.username + "'s Thoughts",
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
            itemCount: visitThoughtsList == null ? 0 : visitThoughtsList.length,
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
                        .format(visitThoughtsList[index].timestamp)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(visitThoughtsList[index].text),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}