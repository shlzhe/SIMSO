import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';
import '../model/entities/user-model.dart';
import '../model/entities/thought-model.dart';
import '../view/design-constants.dart';
import '../view/navigation-drawer.dart';
import '../controller/my-thoughts-controller.dart';

class MyThoughtsPage extends StatefulWidget {
  final UserModel user;
  List<Thought> myThoughtsList;

  MyThoughtsPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return MyThoughtsPageState(user);
  }
}

class MyThoughtsPageState extends State<MyThoughtsPage> {
  BuildContext context;
  MyThoughtsController controller;

  UserModel user;
  List<Thought> myThoughtsList;

  //bool entry = false; //keep, there was something I liked about this snippet of code from Hiep

  var formKey = GlobalKey<FormState>();

  MyThoughtsPageState(this.user) {
    controller = MyThoughtsController(this);

    controller.getMyThoughtsList(this.user.uid);
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var childButtons = List<UnicornButton>();

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Thoughts",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Add Thoughts",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.bubble_chart,
            color: Colors.black,
          ),
          onPressed: controller.addThought,
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Photos",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Add Photos",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.camera,
            color: Colors.black,
          ),
          onPressed: null,
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Memes",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Add Memes",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.mood,
            color: Colors.black,
          ),
          onPressed: null,
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Music",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Add Music",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.music_note,
            color: Colors.black,
          ),
          onPressed: null,
        ),
      ),
    );
    return Scaffold(
        floatingActionButton: UnicornDialer(
          backgroundColor: Colors.transparent,
          parentButtonBackground: Colors.blueGrey[300],
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(
            Icons.add,
          ),
          childButtons: childButtons,
        ),
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
        drawer: MyDrawer(context, user),
        body: Container(
          color: DesignConstants.blueGreyish,
          child: ListView.builder(
            itemCount: myThoughtsList == null ? 0 : myThoughtsList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  //padding: EdgeInsets.all(15.0),
                  //color: Colors.grey[200],
                  padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
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
                    onTap: () => null,
                  ),
                ),
              );
            },
          ),
        ));
  }
}
