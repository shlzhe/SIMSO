import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import '../model/entities/user-model.dart';
import '../model/entities/thought-model.dart';
import '../view/design-constants.dart';
import '../view/navigation-drawer.dart';
import '../controller/edit-thought-controller.dart';
import 'package:flutter/rendering.dart';
import '../model/entities/globals.dart' as globals;

class EditThoughtPage extends StatefulWidget {
  final UserModel user;
  final Thought thought;
  final List<String> myKeywords;

  EditThoughtPage(this.user, this.thought, this.myKeywords);

  @override
  State<StatefulWidget> createState() {
    return EditThoughtPageState(user, thought, myKeywords);
  }
}

class EditThoughtPageState extends State<EditThoughtPage> {
  BuildContext context;
  EditThoughtController controller;

  UserModel user;
  Thought thought;
  Thought thoughtCopy;
  List<String> myKeywords;

  var formKey = GlobalKey<FormState>();

  EditThoughtPageState(this.user, this.thought, this.myKeywords) {
    controller = EditThoughtController(this);
    thoughtCopy = Thought.clone(thought);
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    globals.context = context;
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
          onPressed: null,
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
          parentButtonBackground: DesignConstants.red,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(
            Icons.delete,
          ),
          //childButtons: childButtons,
          onMainButtonPressed: () => controller.deleteThought(),
        ),
        appBar: AppBar(
          title: Text(
            'Edit Your Thought',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 30.0,
                color: DesignConstants.yellow),
          ),
          backgroundColor: DesignConstants.blue,
        ),
        drawer: MyDrawer(context, user),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextFormField(
                    maxLines: 5,
                    initialValue: thoughtCopy.text,
                    validator: controller.validateText,
                    onSaved: controller.saveText,
                    style: TextStyle(fontSize: 22.0, color: Colors.grey[700]),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Ex. Blue',
                      hintStyle:
                          TextStyle(fontSize: 20.0, color: Colors.grey[400]),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 14.0, bottom: 8.0),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: RaisedButton(
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: 22.0, color: Colors.grey[900]),
                    ),
                    onPressed: controller.save,
                    padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: Text('Keywords: ' + myKeywords.toString()),
                  
                ),
                
              ],
            ),
          ),
        ));
  }
}
