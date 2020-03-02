import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/friend-service.dart';
import 'package:simso/model/services/ifriend-service.dart';

import '../service-locator.dart';

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
  var text;
  RecommendFriendsState(this.currentUser);
  final IFriendService friendService = locator<IFriendService>();
  List<UserModel> userList;

  Future<List<UserModel>> getList() async {
    return await friendService.getUsers();
  }

  void stateChanged(Function f) {
    setState(f);
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
            userList = snapshot.data ?? [];
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                UserModel friendUser = userList[index];
                return new ListTile(
                  leading: CircleAvatar(
                      backgroundImage: null // AssetImage(user.profilePicture),
                      ),
                  title: new Text(friendUser.email),
                  onTap: () {
                    _showDialog(context, friendUser).then(
                      (value) {
                        var mySnackbar =
                            SnackBar(content: Text("Friend Request sent"));
                        Scaffold.of(context).showSnackBar(mySnackbar);
                      },
                    );
                  print(text);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<String> _showDialog(BuildContext context, UserModel friendUser) {
    return showDialog(
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
                _sendRequest(friendUser);
                Navigator.of(context).pop();
              },
              child: new Text('Send Friend Request'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendRequest(UserModel friendUser) async {
    if ((await friendService.checkFriendRequest(currentUser, friendUser)) !=
        false) {
      text = "Friend request is already sent";
    } else {
      text = "Friend request sent";
      friendService.addFriendRequest(currentUser, friendUser);
    }
  }
}
