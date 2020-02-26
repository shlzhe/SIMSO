import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/friend-service.dart';

class RecommendFriends extends StatefulWidget {
  final UserModel currentUser;
  RecommendFriends(this.currentUser);
  @override
  State<StatefulWidget> createState() {
    return RecommendFriendsState(currentUser);
  }
}

class RecommendFriendsState extends State<RecommendFriends> {
  UserModel currentUser;
  RecommendFriendsState(this.currentUser);
  FriendService _friendService = new FriendService();
  List<UserModel> friendList = new List<UserModel>();
  Future<List<UserModel>> getList() async {
    return await _friendService.getUsers();
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
                UserModel friendUser = users[index];
                return new ListTile(
                  leading: CircleAvatar(
                      backgroundImage: null // AssetImage(user.profilePicture),
                      ),
                  title: new Text(friendUser.email),
                  onTap: () {
                    _showDialog(friendUser);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDialog(UserModel friendUser) {
    showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: new Text(friendUser.email),
          content: Icon(Icons.account_box),
          actions: <Widget>[
            new FlatButton(
              onPressed: null,
              child: new Text('View Profile'),
            ),
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendRequest(friendUser);
              },
              child: new Text('Send Friend Request'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendRequest(UserModel friendUser) async {
  if((await _friendService.checkFriendRequest(currentUser, friendUser)) != false){
    print("Friend request already sent");
  } else {
    print("Friend request not sent");
  _friendService.addFriendRequest(currentUser, friendUser);
  }
  
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
