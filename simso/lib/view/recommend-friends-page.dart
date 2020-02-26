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
  Future<List<UserModel>> getList() async {
    return await FriendService().getUsers();
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
                      backgroundImage: null // AssetImage(user.profilePicture),
                      ),
                  title: new Text(user.email),
                  onTap: () {
                    _showDialog(user);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: new Text(user.email),
          content: Icon(Icons.account_box),
          actions: <Widget>[
            new FlatButton(
              onPressed: null,
              child: new Text('View Profile'),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendRequest(user);
              },
              child: new Text('Send Friend Request'),
            ),
          ],
        );
      },
    );
  }

  void _sendRequest(UserModel user) {

    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) {
    //     Future.delayed(Duration(milliseconds: 500), () {
    //       Navigator.of(context, rootNavigator: true).pop();
    //     });
    //     return Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //         new ListTile(
    //           leading: Icon(Icons.announcement),
    //           title: new Text('Friend Request Send'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
