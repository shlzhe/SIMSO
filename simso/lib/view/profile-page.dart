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
        // UserAccountsDrawerHeader(
        // decoration: BoxDecoration(color: DesignConstants.blue),
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
          'Profile Feed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Container(),
      ]),
    );
  }
}
