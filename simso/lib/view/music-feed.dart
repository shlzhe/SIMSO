import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simso/controller/music-feed-controller.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import 'package:simso/model/services/isong-service.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/model/services/song-service.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/profile-page.dart';
import '../model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import '../controller/my-music-controller.dart';
import '../service-locator.dart';
import 'design-constants.dart';
import 'dart:async';
import '../model/entities/globals.dart' as globals;

class MusicFeed extends StatefulWidget {
  final UserModel user;
  final List<UserModel> allUserList;
  final List<SongModel> allSongList;

  MusicFeed(this.user, this.allUserList, this.allSongList);
  @override
  State<StatefulWidget> createState() {
    return MusicFeedState(user, allUserList, allSongList);
  }
}

class MusicFeedState extends State<MusicFeed> {
  //final navigatorKey = GlobalKey<NavigatorState>();
  MusicFeedController controller;
  BuildContext context;
  List<UserModel> allUserList;
  UserModel user;
  SongModel song;
  SongModel songCopy;
  bool visit = false;
  List<SongModel> songlist;
  List<SongModel> allSongList = [];
  List<int> deleteIndices;
  int currentScreenIndex = 0;
  int songCount = songNum;
  ISongService _songService = locator<ISongService>();
  IUserService _userService = locator<IUserService>();
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  ILimitService limitService = locator<ILimitService>();
  bool meme = false;
  bool music = true;
  bool snapshots = false;
  bool thoughts = false;
  bool friends = false;
  List<Thought> publicThoughtsList = [];

  MusicFeedState(this.user, this.allUserList, this.allSongList) {
    controller = MusicFeedController(this);
    if (song == null) {
      songCopy = SongModel.empty();
    } else {
      songCopy = SongModel.clone(song);
    }
  }

  void stateChanged(Function fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    globals.context = context;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
          textTheme: Typography(platform: TargetPlatform.iOS).white,
          fontFamily: 'Quantum',
        ),
        home: Scaffold(
          // appBar: AppBar(
          //   leading: IconButton(
          //     icon: Icon(
          //       Icons.arrow_back_ios,
          //       color: DesignConstants.yellow,
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   backgroundColor: DesignConstants.blue,
          //   title: Text(
          //     'Music Feed',
          //     style: TextStyle(
          //       color: DesignConstants.yellow,
          //     ),
          //   ),
          // ),
          body: ListView.builder(
            itemCount: allSongList.length,
            itemBuilder: (context, index) => Container(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    //for (UserModel users in allUserList)
                    for (UserModel users in allUserList)
                      Container(
                        child: allSongList[index].createdBy == users.email
                            ? Container(
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            users.profilePic.isNotEmpty
                                                ? users.uid == user.uid
                                                    ? FlatButton(
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(users
                                                                  .profilePic),
                                                          radius: 22.0,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            visit = false;
                                                          });
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfilePage(
                                                                      user,
                                                                      user,
                                                                      visit),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : FlatButton(
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(users
                                                                  .profilePic),
                                                          radius: 22.0,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            visit = true;
                                                          });
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfilePage(
                                                                      users,
                                                                      null,
                                                                      visit),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                : users.uid == user.uid
                                                    ? FlatButton(
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  DesignConstants
                                                                      .profile),
                                                          radius: 22.0,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            visit = false;
                                                          });
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfilePage(
                                                                      user,
                                                                      null,
                                                                      visit),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : FlatButton(
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  DesignConstants
                                                                      .profile),
                                                          radius: 22.0,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            visit = true;
                                                          });
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfilePage(
                                                                      users,
                                                                      null,
                                                                      visit),
                                                            ),
                                                          );
                                                        },
                                                      )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                users.username.isNotEmpty
                                                    ? Container(
                                                        child: Text(
                                                          '${users.username}',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        child: Text(
                                                          'Username Unavailable',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '${allSongList[index].genre}',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '${allSongList[index].title}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueGrey[100],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints.expand(height: 300),
                        child: FlatButton(
                          onPressed: () {},
                          padding: EdgeInsets.all(0.0),
                          child: CachedNetworkImage(
                            imageUrl: allSongList[index].artWork,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   child: CachedNetworkImage(
                    //     imageUrl: allSongList[index].artWork,
                    //     placeholder: (context, url) =>
                    //         CircularProgressIndicator(),
                    //     errorWidget: (context, url, error) =>
                    //         Icon(Icons.error_outline),
                    //   ),
                    // ),
                    for (UserModel users in allUserList)
                      Container(
                        child: allSongList[index].createdBy == users.email
                            ? Container(
                                padding: EdgeInsets.only(
                                  left: 22.0,
                                  top: 10.0,
                                ),
                                child: users.username.isNotEmpty
                                    ? Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              '${users.username}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text('Username Unavailable'),
                                          ],
                                        ),
                                      ),
                              )
                            : Container(),
                      ),
                    Container(
                      padding: EdgeInsets.only(left: 22),
                      child: Row(
                        children: <Widget>[
                          Text('${allSongList[index].lastUpdatedAt}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // bottomNavigationBar: BottomAppBar(
          //   color: Colors.black,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       RaisedButton(
          //         child: Text(
          //           'Thoughts',
          //           style: TextStyle(color: DesignConstants.yellow),
          //         ),
          //         onPressed: controller.newContent,
          //         color: thoughts
          //             ? DesignConstants.blueLight
          //             : DesignConstants.blue,
          //       ),
          //       RaisedButton(
          //         child: Text(
          //           'Memes',
          //           style: TextStyle(color: DesignConstants.yellow),
          //         ),
          //         onPressed: controller.meme,
          //         color:
          //             meme ? DesignConstants.blueLight : DesignConstants.blue,
          //       ),
          //       RaisedButton(
          //         child: Text(
          //           'SnapShots',
          //           style: TextStyle(color: DesignConstants.yellow),
          //         ),
          //         onPressed: controller.snapshots,
          //         color: snapshots
          //             ? DesignConstants.blueLight
          //             : DesignConstants.blue,
          //       ),
          //       RaisedButton(
          //         child: Text(
          //           'Music',
          //           style: TextStyle(color: DesignConstants.yellow),
          //         ),
          //         onPressed: controller.music,
          //         color:
          //             music ? DesignConstants.blueLight : DesignConstants.blue,
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
