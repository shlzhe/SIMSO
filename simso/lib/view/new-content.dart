import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:simso/controller/new-content-page-controller.dart';
import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/meme-model.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
import 'package:simso/view/design-constants.dart';
import 'package:simso/view/profile-page.dart';

import 'emoji-container.dart';
import 'music-feed.dart';

class NewContentPage extends StatefulWidget {
  final UserModel user;
  NewContentPage(this.user);
  @override
  State<StatefulWidget> createState() {
    return NewContentPageState(user);
  }
}

class NewContentPageState extends State<NewContentPage> {
  UserModel user;
  NewContentPageController controller;
  BuildContext context;
  IUserService userService = locator<IUserService>();
  bool meme = false;
  bool music = false;
  bool snapshots = false;
  bool thoughts = true;
  bool friends = false;
  bool visit = false;
  List<Thought> publicThoughtsList = [];
  List<SongModel> songsList = [];
  List<Meme> memesList = [];
  List<ImageModel> imageList = [];
  List<UserModel> allUsersList = [];
  List<SongModel> allSongsList = [];

  gotoProfile(String uid) async {
    UserModel visitUser = await userService.readUser(uid);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfilePage(user, visitUser, true)));
  }

  void stateChanged(Function f) {
    setState(f);
  }

  NewContentPageState(this.user) {
    controller = NewContentPageController(this);
    controller.thoughts();
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: music ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          !thoughts && !meme && !snapshots && !music
              ? 'New Content'
              : thoughts
                  ? 'Thoughts'
                  : (meme ? 'Memes' : (snapshots ? 'SnapShots' : 'Music')),
          style: TextStyle(color: DesignConstants.yellow),
        ),
        backgroundColor: DesignConstants.blue,
      ),
      body: thoughts
          ? ListView.builder(
              itemCount: publicThoughtsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    //color: Colors.grey[200],
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
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
                          icon: publicThoughtsList
                                      .elementAt(index)
                                      .profilePic !=
                                  ''
                              ? Builder(builder: (BuildContext context) {
                                  try {
                                    return Container(
                                        width: 35,
                                        height: 35,
                                        child: Image.network(publicThoughtsList
                                            .elementAt(index)
                                            .profilePic));
                                  } on PlatformException {
                                    return Icon(Icons.error_outline);
                                  }
                                })
                              : Icon(Icons.error_outline),
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
                          Text(
                            publicThoughtsList.elementAt(index).text,
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                      trailing: EmojiContainer(
                        this.context,
                        this.user,
                        mediaTypes.thought.index,
                        publicThoughtsList[index].thoughtId,
                        publicThoughtsList[index].uid,
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
                                child: Text(memesList[index].email),
                                onTap: () {}),
                            subtitle: Text(
                                DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
                                    .format(memesList[index].timestamp)),
                            trailing: EmojiContainer(
                              this.context,
                              this.user,
                              mediaTypes.meme.index,
                              memesList[index].memeId,
                              memesList[index].ownerID,
                            ),
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
                                trailing: EmojiContainer(
                                  this.context,
                                  this.user,
                                  mediaTypes.snapshot.index,
                                  imageList[index].imageId,
                                  imageList[index].ownerID,
                                ),
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
                                                                           gotoProfile(users.uid);
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
                                                                          gotoProfile(user.uid);
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
                                                                          gotoProfile(users.uid);
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
                                                        EmojiContainer(
                                                          this.context,
                                                          this.user,
                                                          mediaTypes.music.index,
                                                          allSongsList[index].songId,
                                                          users.uid,
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
                                        onPressed: () {},
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
}
