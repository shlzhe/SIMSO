import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/friend-service.dart';

class RecommendFriends extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecommendFriendsState();
  }
}

class RecommendFriendsState extends State<RecommendFriends> {

  List<UserModel> friendList = new List<UserModel>();
  Future<List<UserModel>> getList() async{
    return await FriendService().getFriend();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Recommend Friends'),
      ),
      body: new Container(
        child: new FutureBuilder(
          future: getList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return new Text('Loading...');
            }
            if (snapshot.hasError) {
              return new Text(snapshot.error.toString());
            }
            List<UserModel> users = snapshot.data ?? [];
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserModel user = users[index];
                  return new ListTile(
                    leading: CircleAvatar(
                      backgroundImage:null // AssetImage(user.profilePicture),
                    ),
                    title: new Text(user.email),
                    onTap: null
                  );
                });
          },
        ),
      ),
    );
  }
}
