import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/navigation-drawer.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/homepage-controller.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/model/services/ifriend-service.dart';
import 'package:simso/view/friends-page.dart';
import 'package:simso/view/notification-page.dart' ;
import '../model/entities/user-model.dart';
import '../model/entities/friendRequest-model.dart';
import 'package:simso/model/entities/friend-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';

class Homepage extends StatefulWidget {
  final UserModel user;

  Homepage(this.user);

  @override
  State<StatefulWidget> createState() {
    return HomepageState(user);
  }
}

class HomepageState extends State<Homepage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  final IFriendService friendService = locator<IFriendService>();
  HomepageController controller;
  UserModel user;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  HomepageState(this.user) {
    controller = HomepageController(this, this.timerService, this.touchService);
    controller.setupTimer();
    controller.setupTouchCounter();
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
          onPressed: controller.addPhotos,
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
          onPressed: () {},
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
          onPressed: controller.addMusic,
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
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications), 
          onPressed:  myFriendsRequest, 
          )
        ],
      ),
      drawer: MyDrawer(context, user),
      body: Container(
          child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
          ],
        ),
      )),
    );
  }




  void myFriendsRequest() async {
    List<FriendRequests> friendRequests = await friendService.getFriendRequests(user.friendRequestRecieved);
     Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationPage(user, friendRequests)));
  }

}
