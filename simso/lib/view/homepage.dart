import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/meme-model.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import 'package:simso/model/services/ipicture-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/music-feed.dart';
import 'package:simso/view/navigation-drawer.dart';
import 'package:simso/view/profile-page.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/homepage-controller.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';
import '../model/entities/friendRequest-model.dart';
import 'package:simso/model/services/ifriend-service.dart';
import 'package:simso/view/notification-page.dart';

import 'emoji-container.dart';

class Homepage extends StatefulWidget {
  final UserModel user;
  final List<SongModel> songlist;

  Homepage(this.user, this.songlist);

  @override
  State<StatefulWidget> createState() {
    return HomepageState(user);
  }
}

class HomepageState extends State<Homepage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  ILimitService limitService = locator<ILimitService>();
  IImageService imageService = locator<IImageService>();
  final IFriendService friendService = locator<IFriendService>();
  bool meme = false;
  bool music = false;
  bool snapshots = false;
  bool thoughts = true;
  bool friends = true;
  bool visit = false;
  List<Thought> publicThoughtsList = [];
  HomepageController controller;
  UserModel user;
  List<SongModel> songs;
  List<UserModel> visitUser;
  List<ImageModel> imageList = [];
  List<SongModel> allSongsList = [];
  List<UserModel> allUsersList = [];
  List<Meme> memesList;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  HomepageState(this.user) {
    controller = HomepageController(this, this.timerService, this.touchService,
        this.limitService, this.allSongsList);
    controller.setupTimer();
    controller.setupTouchCounter();
    controller.getLimits();
    controller.thoughts();
  }

  gotoProfile(String uid) async {
    UserModel visitUser = await userService.readUser(uid);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfilePage(visitUser, true)));
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var childButtons = List<UnicornButton>();

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Thoughts",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Add Thoughts",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.bubble_chart,
            color: Colors.black,
          ),
          onPressed: controller.addThought,
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Photos",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Add Photos",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.camera,
            color: Colors.black,
          ),
          onPressed: controller.addPhotos,
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Memes",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Add Memes",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.mood,
            color: Colors.black,
          ),
          onPressed: controller.navigateToMemes,
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Music",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Add Music",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.music_note,
            color: Colors.black,
          ),
          onPressed: controller.addMusic,
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Messenger",
        labelFontSize: 10,
        currentButton: FloatingActionButton(
          heroTag: "Messenger",
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.textsms,
            color: Colors.black,
          ),
          onPressed: controller.mainChatScreen,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: music ? Colors.black : Colors.white,
      floatingActionButton: UnicornDialer(
        backgroundColor: Colors.transparent,
        parentButtonBackground: Colors.blueGrey[300],
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(
          Icons.add,
        ),
        childButtons: childButtons,
      ),
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: DesignConstants.blue,
        actions: <Widget>[
          IconButton(
            onPressed: controller.newContent,
            icon: Icon(
              Icons.search,
              size: 25,
            ),
            iconSize: 200,
            color: DesignConstants.yellow,
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: myFriendsRequest,
          ),
        ],
      ),
      drawer: MyDrawer(context, user),
      body: thoughts
          ? ListView.builder(
              itemCount: publicThoughtsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    decoration: BoxDecoration(
                      color: music ? Colors.black : Color(0xFFFFFFFF),
                      border: Border.all(
                        color: DesignConstants.blue,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: () {
                            gotoProfile(
                                publicThoughtsList.elementAt(index).uid);
                          },
                          icon: Image.network(
                            publicThoughtsList.elementAt(index).profilePic,
                            scale: 10,
                          ),
                          label: Expanded(
                            child: Text(
                              publicThoughtsList.elementAt(index).email +
                                  ' ' +
                                  publicThoughtsList
                                      .elementAt(index)
                                      .timestamp
                                      .toLocal()
                                      .toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(publicThoughtsList.elementAt(index).text),
                          EmojiContainer(
                            this.context,
                            this.user,
                            mediaTypes.thought.index,
                            publicThoughtsList[index].thoughtId,
                            publicThoughtsList[index].uid,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : (meme
              ? ListView.builder(
                  itemCount: memesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              gotoProfile(memesList[index].ownerID);
                            },
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  memesList[index].ownerPic),
                              backgroundColor: Colors.grey,
                            ),
                            title: GestureDetector(
                                child: Text(memesList[index].ownerName),
                                onTap: () {}),
                            subtitle: Text(
                                DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
                                    .format(memesList[index].timestamp)),
                          ),
                          Container(
                            child: CachedNetworkImage(
                              imageUrl: memesList[index].imgUrl,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline),
                            ),
                          ),
                          EmojiContainer(
                            this.context,
                            this.user,
                            mediaTypes.meme.index,
                            memesList[index].memeId,
                            memesList[index].ownerID,
                          )
                        ],
                      ),
                    );
                  },
                )
              : snapshots
                  ? ListView.builder(
                      itemCount: imageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                onTap: () {
                                  gotoProfile(imageList[index].ownerID);
                                },
                                leading:
                                    imageList[index].ownerPic.contains('http')
                                        ? CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              imageList[index].ownerPic,
                                            ),
                                            backgroundColor: Colors.grey,
                                          )
                                        : Icon(Icons.error_outline),
                                title: GestureDetector(
                                    child: Text(imageList[index].createdBy),
                                    onTap: () {}),
                                subtitle: Text(DateFormat(
                                        "MMM dd-yyyy 'at' HH:mm:ss")
                                    .format(imageList[index].lastUpdatedAt)),
                              ),
                              Container(
                                child: CachedNetworkImage(
                                  imageUrl: imageList[index].imageURL,
                                  fit: BoxFit.fitWidth,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error_outline),
                                ),
                              ),
                              EmojiContainer(
                                this.context,
                                this.user,
                                mediaTypes.snapshot.index,
                                imageList[index].imageId,
                                imageList[index].ownerID,
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : music
                      ? ListView.builder(
                          itemCount: allSongsList.length,
                          itemBuilder: (context, index) => Container(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  //for (UserModel users in allUserList)
                                  for (UserModel users in allUsersList)
                                    Container(
                                      child:
                                          allSongsList[index].createdBy ==
                                                  users.email
                                              ? Container(
                                                  child: Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          child: Column(
                                                            children: <Widget>[
                                                              users.profilePic
                                                                      .isNotEmpty
                                                                  ? users.uid ==
                                                                          user
                                                                              .uid
                                                                      ? FlatButton(
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundImage:
                                                                                NetworkImage(users.profilePic),
                                                                            radius:
                                                                                22.0,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              visit = false;
                                                                            });
                                                                            gotoProfile(user.uid);
                                                                          },
                                                                        )
                                                                      : FlatButton(
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundImage:
                                                                                NetworkImage(users.profilePic),
                                                                            radius:
                                                                                22.0,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              visit = true;
                                                                            });
                                                                            Navigator.of(context).push(
                                                                              MaterialPageRoute(
                                                                                builder: (context) => ProfilePage(users, visit),
                                                                              ),
                                                                            );
                                                                          },
                                                                        )
                                                                  : users.uid ==
                                                                          user.uid
                                                                      ? FlatButton(
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundImage:
                                                                                NetworkImage(DesignConstants.profile),
                                                                            radius:
                                                                                22.0,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              visit = false;
                                                                            });
                                                                            Navigator.of(context).push(
                                                                              MaterialPageRoute(
                                                                                builder: (context) => ProfilePage(user, visit),
                                                                              ),
                                                                            );
                                                                          },
                                                                        )
                                                                      : FlatButton(
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundImage:
                                                                                NetworkImage(DesignConstants.profile),
                                                                            radius:
                                                                                22.0,
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              visit = true;
                                                                            });
                                                                            Navigator.of(context).push(
                                                                              MaterialPageRoute(
                                                                                builder: (context) => ProfilePage(users, visit),
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
                                                                children: <
                                                                    Widget>[
                                                                  users.username
                                                                          .isNotEmpty
                                                                      ? Container(
                                                                          child:
                                                                              Text(
                                                                            '${users.username}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          child:
                                                                              Text(
                                                                            'Username Unavailable',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    '${allSongsList[index].genre}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          11,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '${allSongsList[index].title}',
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
                                      constraints:
                                          BoxConstraints.expand(height: 300),
                                      child: FlatButton(
                                        onPressed: () {
                                          setState(() {
                                            controller.playpause(
                                                allSongsList[index].songURL);
                                          });
                                        },
                                        padding: EdgeInsets.all(0.0),
                                        child: CachedNetworkImage(
                                          imageUrl: allSongsList[index].artWork,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error_outline),
                                        ),
                                      ),
                                    ),
                                  ),
                                  for (UserModel users in allUsersList)
                                    Container(
                                      child: allSongsList[index].createdBy ==
                                              users.email
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
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                              'Username Unavailable'),
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
                                        Text(
                                            '${allSongsList[index].lastUpdatedAt}',
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
                        )
                      : null),
      bottomNavigationBar: BottomAppBar(
        color: music ? Colors.black : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'Thoughts',
                style: TextStyle(color: DesignConstants.yellow),
              ),
              onPressed: controller.thoughts,
              color:
                  thoughts ? DesignConstants.blueLight : DesignConstants.blue,
            ),
            RaisedButton(
              child: Text(
                'Memes',
                style: TextStyle(color: DesignConstants.yellow),
              ),
              onPressed: controller.meme,
              color: meme ? DesignConstants.blueLight : DesignConstants.blue,
            ),
            RaisedButton(
              child: Text(
                'SnapShots',
                style: TextStyle(color: DesignConstants.yellow),
              ),
              onPressed: controller.snapshots,
              color:
                  snapshots ? DesignConstants.blueLight : DesignConstants.blue,
            ),
            RaisedButton(
              child: Text(
                'Music',
                style: TextStyle(color: DesignConstants.yellow),
              ),
              onPressed: controller.music,
              color: music ? DesignConstants.blueLight : DesignConstants.blue,
            ),
          ],
        ),
      ),
    );
  }

  void myFriendsRequest() async {
    print('myFriendRequest() called');
    List<FriendRequests> friendRequests =
        await friendService.getFriendRequests(user.friendRequestRecieved);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationPage(user, friendRequests)));
  }
}
