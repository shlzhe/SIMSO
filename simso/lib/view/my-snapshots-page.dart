import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';
import '../model/entities/user-model.dart';
import '../model/entities/snapshot-model.dart';
import '../view/design-constants.dart';
import '../view/navigation-drawer.dart';
import '../controller/my-snapshots-controller.dart';
import '../controller/my-thoughts-controller.dart' as addthought;
import 'package:cached_network_image/cached_network_image.dart';

class MySnapshotsPage extends StatefulWidget {
  final UserModel user;
  List<Snapshot> mySnapshotsList;

  MySnapshotsPage(this.user, this.mySnapshotsList);

  @override
  State<StatefulWidget> createState() {
    return MySnapshotsPageState(user, mySnapshotsList);
  }
}

class MySnapshotsPageState extends State<MySnapshotsPage> {
  BuildContext context;
  MySnapshotsController controller;

  UserModel user;
  List<Snapshot> mySnapshotsList;

  //bool entry = false; //keep, there was something I liked about this snippet of code from Hiep

  var formKey = GlobalKey<FormState>();

  MySnapshotsPageState(this.user, this.mySnapshotsList) {
    controller = MySnapshotsController(this);
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
            onPressed: null
            //addthought.MyThoughtsController.addThought,
            ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Snapshots",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Add Snapshots",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.camera,
            color: Colors.black,
          ),
          onPressed: controller.addSnapshot,
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
            'My Snapshots',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 30.0,
                color: DesignConstants.yellow),
          ),
          backgroundColor: DesignConstants.blue,
        ),
        drawer: MyDrawer(context, user),
        body: ListView.builder(
            itemCount: mySnapshotsList == null ? 0 : mySnapshotsList.length,
            itemBuilder: (BuildContext context, int index) {
              if (mySnapshotsList != null) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                mySnapshotsList[index].ownerPic),
                            backgroundColor: Colors.grey,
                          ),
                          title: GestureDetector(
                            child: Text(mySnapshotsList[index].ownerName),
                            onTap: () =>
                                controller.onTapProfile(mySnapshotsList, index),
                          ),
                          subtitle: Text(DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
                              .format(mySnapshotsList[index].timestamp)),
                          trailing: GestureDetector(
                            child: const Icon(Icons.edit),
                            onTap: () => controller.onTapSnapshot(
                                mySnapshotsList, index),
                          )),
                          
                      CachedNetworkImage(
                        imageUrl: mySnapshotsList[index].imgUrl,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      ),
                    ],
                  ),
                );
              } else
                return null;
            }));

    // Container(
    //   color: DesignConstants.blueGreyish,
    //   child: ListView.builder(
    //     itemCount: mySnapshotsList == null ? 0 : mySnapshotsList.length,
    //     itemBuilder: (BuildContext context, int index) {
    // return Container(
    //   padding: EdgeInsets.all(15.0),
    //   child: Container(
    //     //padding: EdgeInsets.all(15.0),
    //     //color: Colors.grey[200],
    //     padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
    //     decoration: BoxDecoration(
    //       color: const Color(0xFFFFFFFF),
    //       border: Border.all(
    //         color: DesignConstants.blue,
    //         width: 4,
    //       ),
    //       borderRadius: BorderRadius.circular(30),
    //     ),
    //     child: ListTile(
    //       title: Text(DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
    //           .format(mySnapshotsList[index].timestamp)),
    //       subtitle: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           CachedNetworkImage(
    //             imageUrl: mySnapshotsList[index].imgUrl,
    //             placeholder: (context, url) =>
    //                 CircularProgressIndicator(),
    //             errorWidget: (context, url, error) =>
    //                 Icon(Icons.error_outline),
    //           ),
    //         ],
    //       ),
    //       onTap: () =>
    //           controller.onTapSnapshot(mySnapshotsList, index),
    //     ),
    //   ),
    // );
    //     },
    //   ),
    // )
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );
}
