import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ifriend-service.dart';

import '../service-locator.dart';
import 'design-constants.dart';

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
  final IFriendService friendService = locator<IFriendService>();
  List<UserModel> userList = new List<UserModel>();

  Future<List<UserModel>> getList() {
    return friendService.getUsers();
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
            if (userList.isNotEmpty) {
              userList = _recommendFunction(userList);
            }
            for (var i in userList) {
              print(i.email);
            }
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                UserModel friendUser = userList[index];
                return new ListTile(
                  leading: CircleAvatar(
                    child: CachedNetworkImage(
                      imageUrl: friendUser.profilePic != null && friendUser.profilePic != ''
                          ? friendUser.profilePic
                          : DesignConstants.profile,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.account_circle),
                    ),
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
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<UserModel> _recommendFunction(List<UserModel> theList) {
    List<UserModel> holdList = new List<UserModel>();
    theList.shuffle();
    var count = 10;
    for (var i in theList) {
      if (i.uid != currentUser.uid &&
          i.email != currentUser.email &&
          count > 0) {
        print(i);
        holdList.add(i);
        count--;
      }
    }
    return holdList;
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
    friendService.addFriendRequest(currentUser, friendUser);
  }
}
