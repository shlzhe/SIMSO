import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import '../model/entities/user-model.dart';
import '../model/entities/snapshot-model.dart';
import '../view/design-constants.dart';
import '../view/navigation-drawer.dart';
import '../controller/add-snapshot-controller.dart';

class AddSnapshotPage extends StatefulWidget {
  final UserModel user;
  final Snapshot snapshot;

  AddSnapshotPage(this.user, this.snapshot);

  @override
  State<StatefulWidget> createState() {
    return AddSnapshotPageState(user, snapshot);
  }
}

class AddSnapshotPageState extends State<AddSnapshotPage> {
  BuildContext context;
  AddSnapshotController controller;

  UserModel user;
  Snapshot snapshot;
  Snapshot snapshotCopy;

  //bool entry = false; //keep, there was something I liked about this snippet of code from Hiep

  var formKey = GlobalKey<FormState>();

  AddSnapshotPageState(this.user, this.snapshot) {
    controller = AddSnapshotController(this);
    if (snapshot == null) {
      //addButton
      snapshotCopy = Snapshot.empty();
    } else {
      snapshotCopy = Snapshot.clone(snapshot);
    }
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var childButtons = List<UnicornButton>();
    return Scaffold(

        appBar: AppBar(
          actions: snapshot == null
              ? null:<Widget>[
                  IconButton(
                      icon: Icon(Icons.delete), onPressed: controller.deleteSnapshot,
                  )],
          title: Text(
            'Snapshot',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 30.0,
                color: DesignConstants.yellow),
          ),
          backgroundColor: DesignConstants.blue,
        ),
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
                    autofocus: false,
                    initialValue: snapshotCopy.imgUrl,
                    validator: controller.validateImgUrl,
                    onSaved: controller.saveImgUrl,
                    style: TextStyle(fontSize: 22.0, color: Colors.grey[700]),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Input your url',
                      hintStyle:
                          TextStyle(fontSize: 20.0, color: Colors.grey[400]),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
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
                      'Done',
                      style: TextStyle(fontSize: 22.0, color: Colors.grey[900]),
                    ),
                    onPressed: controller.save,
                    padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
