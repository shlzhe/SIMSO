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
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return new Text(snapshot.error.toString());
            }
            userList = snapshot.data ?? [];
            if (userList.isNotEmpty) {
              
              userList = _recommendFunction(userList);
            }
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                UserModel friendUser = userList[index];
                return new ListTile(
                  leading: CircleAvatar(
                    child: CachedNetworkImage(
                      imageUrl: friendUser.profilePic != null &&
                              friendUser.profilePic != ''
                          ? friendUser.profilePic
                          : DesignConstants.profile,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.account_circle),
                    ),
                  ),
                  title: new Text(friendUser.email),
                  onTap: () async {
                    final result = await showDialog(
                      context: this.context,
                      child: _showDialog(context, friendUser),
                    );
                    if (result != null) {
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text("$result")));
                    }
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
        holdList.add(i);
        count--;
      }
    }
    return holdList;
  }

  Widget _showDialog(BuildContext context, UserModel friendUser) {
    return new AlertDialog(
      title: new Text(friendUser.email),
      content: new Container(
        child: CircleAvatar(
          child: CachedNetworkImage(
            imageUrl:
                friendUser.profilePic != null && friendUser.profilePic != ''
                    ? friendUser.profilePic
                    : DesignConstants.profile,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.account_circle),
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: null,
          child: new Text('View Profile'),
        ),
        new FlatButton(
          onPressed: () {
            _sendRequest(friendUser);
            Navigator.pop(context, "Friend Request sent");
          },
          child: new Text('Send Friend Request'),
        ),
      ],
    );
  }

  Future<void> _sendRequest(UserModel friendUser) async =>
      friendService.addFriendRequest(currentUser, friendUser);
}
