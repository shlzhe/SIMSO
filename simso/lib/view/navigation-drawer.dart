import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/navigation-controller.dart';
import 'package:simso/model/entities/user-model.dart';

import 'design-constants.dart';

class MyDrawer extends StatelessWidget {
  final UserModel user;
  MyDrawerController controller;

  MyDrawer(this.user) {
    controller = new MyDrawerController(this);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: DesignConstants.blue),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user.profilePic != null
                      ? user.profilePic
                      : "https://image.flaticon.com/icons/png/512/64/64572.png",
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.account_circle),
                ),
              ),
            ),
            accountName: Text(user.username),
            accountEmail: Text(user.email),
          ),
          ListTile(
            leading: Icon(Icons.format_quote),
            title: Text('My Quotes'),
            onTap: controller.navigateHomepage,
          ),
        ],
      ),
    );
  }
}