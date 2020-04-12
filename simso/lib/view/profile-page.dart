import 'package:flutter/material.dart';
import 'package:simso/view/design-constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/entities/user-model.dart';
import '../controller/profile-page-controller.dart';

class ProfilePage extends StatefulWidget {
  final UserModel visitUser;
  final UserModel currentUser;
  final bool visit;
  ProfilePage(this.currentUser, this.visitUser, this.visit);

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(currentUser, visitUser, visit);
  }
}

class ProfilePageState extends State<ProfilePage> {
  UserModel visitUser;
  UserModel ogUser;
  UserModel currentUser;

  bool visit;
  ProfilePageController controller;
  var formKey = GlobalKey<FormState>();
  BuildContext context;

  ProfilePageState(this.currentUser, this.visitUser, this.visit) {
    controller = ProfilePageController(this);
  }

  void stateChanged(Function fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {  
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(visitUser.username + ' Profile'),
        backgroundColor: DesignConstants.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          visit == false
              ? IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: controller.accountSettings,
                )
              : Container(),
        ],
      ),
      body: ListView(children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          width: 70,
          height: 120,
          child: CachedNetworkImage(
            imageUrl: visitUser.profilePic != null && visitUser.profilePic != ''
                ? visitUser.profilePic
                : DesignConstants.profile,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.account_circle),
          ),
        ),
        Text(
          'My Profile',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Text(''),
        Text(
          'Email: ' + visitUser.email,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Text(
          'Username: ' + visitUser.username,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        if (visitUser.age == 0)
          Text(
            'Age: ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: (TextAlign.center),
          ),
        if (visitUser.age != 0)
          Text(
            'Age: ' + visitUser.age.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: (TextAlign.center),
          ),
        visitUser.gender != null
            ? Text(
                'Gender: ' + visitUser.gender,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: (TextAlign.center),
              )
            : Text(
                'Gender: Uavailable',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: (TextAlign.center),
              ),
        Text(
          'City: ' + visitUser.city,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Text(
          'Bio: ' + visitUser.aboutme,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
                        Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black)),
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.music_note),
                      Text("Songs")
                    ],
                  ),
                  onPressed: () => {},
                ),
              ],
            ),
                        Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black)),
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.mood),
                      Text("Memes")
                    ],
                  ),
                  onPressed: () => {},
                ),
              ],
            ),
                        Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black)),
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.camera),
                      Text("Snapshots")
                    ],
                  ),
                  onPressed: () => {},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black)),
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.bubble_chart),
                      Text("Thoughts")
                    ],
                  ),
                  onPressed: controller.thoughtsPage,
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
