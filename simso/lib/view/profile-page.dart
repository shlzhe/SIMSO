import 'package:flutter/material.dart';
import 'package:simso/view/design-constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/entities/user-model.dart';
import '../model/entities/image-model.dart';
import '../controller/profile-page-controller.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  final bool visit;
  ProfilePage(this.user, this.visit);

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(user, visit);
  }
}

class ProfilePageState extends State<ProfilePage> {
  UserModel user;
  UserModel ogUser;
  bool visit;
  ProfilePageController controller;
  var formKey = GlobalKey<FormState>();
  BuildContext context;

  ProfilePageState(this.user, this.visit) {
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
        title: Text(user.username + ' Profile'),
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
            imageUrl: user.profilePic != null && user.profilePic != ''
                ? user.profilePic
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
          'Email: ' + user.email,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Text(
          'Username: ' + user.username,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        if (user.age == 0)
          Text(
            'Age: ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: (TextAlign.center),
          ),
        if (user.age != 0)
          Text(
            'Age: ' + user.age.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: (TextAlign.center),
          ),
        user.gender != null
            ? Text(
                'Gender: ' + user.gender,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: (TextAlign.center),
              )
            : Text(
                'Gender: Uavailable',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: (TextAlign.center),
              ),
        Text(
          'City: ' + user.city,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Text(
          'Bio: ' + user.aboutme,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
      ]),
    );
  }
}
