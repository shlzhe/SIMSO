import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ifriend-service.dart';
import '../controller/recommend-friends-controller.dart';
import 'package:string_similarity/string_similarity.dart';
import '../model/entities/globals.dart' as globals;

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
  RecommendFriendsController controller;
  BuildContext context;

  RecommendFriendsState(this.currentUser) {
    controller = RecommendFriendsController(this, this.currentUser);
  }
  final IFriendService friendService = locator<IFriendService>();
  List<UserModel> userList = new List<UserModel>();
  List<UserModel> showList = new List<UserModel>();
  List<UserModel> searchList = new List<UserModel>();

  TextEditingController inputData = new TextEditingController();
  Future<List<UserModel>> getList() {
    return friendService.getUsers();
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    globals.context = context;

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
              showList = _recommendFunction(userList);
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: TextField(
                          controller: inputData,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter users name'),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: FlatButton(
                            color: Colors.blue,
                            onPressed: () {
                              if (inputData.text.isNotEmpty) {
                                setState(() {
                                  searchList = _searchResult(userList);
                                });
                              }
                            },
                            child: Text("Search")),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _solveConflict(),
                    itemBuilder: (context, index) {
                      UserModel friendUser;
                      if (inputData.text.isNotEmpty) {
                        friendUser = searchList[index];
                      } else {
                        friendUser = showList[index];
                      }
                      return ListTile(
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
                        title: Text(friendUser.email),
                        onTap: () async {
                          final result = await showDialog(
                            context: this.context,
                            child: _showDialog(context, friendUser),
                          );
                          if (result != null) {
                            Scaffold.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                  SnackBar(content: Text("$result")));
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  int _solveConflict() {
    if (inputData.text.isNotEmpty) {
      return searchList.length;
    } else {
      return showList.length;
    }
  }

  List<UserModel> _searchResult(List<UserModel> theList) {
    List<UserModel> holdList = new List<UserModel>();
    var compare = inputData.text;
    print(compare);
    for (var j in theList) {
      if (StringSimilarity.compareTwoStrings(compare, j.email) > 0.35 ||
          StringSimilarity.compareTwoStrings(compare, j.username) > 0.35) {
        print(j.email);
        holdList.add(j);
      }
    }
    return holdList;
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
          onPressed: () {
            controller.viewProfile(friendUser.uid);
          },
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
