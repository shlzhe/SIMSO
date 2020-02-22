import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/homepage.dart';

import 'design-constants.dart';

class MyDrawer extends StatelessWidget {
  final UserModel user;
  final BuildContext context;

  MyDrawer(this.context, this.user);

  void navigateHomepage() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Homepage(user)
    ));
  }

  void signOut(){
    
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
                  imageUrl: user.profilePic != null &&
                            user.profilePic != ''
                      ? user.profilePic
                      : DesignConstants.profile,
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
            leading: Icon(Icons.bubble_chart),
            title: Text('My Thoughts'),
            onTap: navigateHomepage,
          ),
           ListTile(
            leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: signOut,
              ),    //Special Widget for Drawer
        ],
      ),
    );
  }
}