import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/meme-model.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import 'package:simso/model/services/ipicture-service.dart';
import 'package:simso/model/services/itouch-service.dart';
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
  List<Thought> publicThoughtsList = [];
  HomepageController controller;
  UserModel user;
  List<UserModel> visitUser;
  List<ImageModel> imageList =[];
  List<SongModel> songlist;
  List<Meme> memesList;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  HomepageState(this.user) {
    controller = HomepageController(this, this.timerService, this.touchService,
        this.limitService, this.songlist);
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

    return Scaffold(
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
          Row(
            children: <Widget>[
              IconButton(
                onPressed: controller.newContent,
                icon: Icon(
                  Icons.search,
                  size: 25,
                ),
               
                color: DesignConstants.yellow,
              ),
               IconButton(
            icon: Icon(Icons.textsms),
            onPressed: controller.mainChatScreen,
            color: DesignConstants.yellow,
          ),
           IconButton(
            icon: Icon(Icons.notifications),
            onPressed: myFriendsRequest,
            color: DesignConstants.yellow,
          ),
        ],        
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
                        onTap: (){gotoProfile(memesList[index].ownerID);},
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                memesList[index].ownerPic),
                            backgroundColor: Colors.grey,
                          ),
                          title: GestureDetector(
                            child: Text(memesList[index].ownerName),
                            onTap: (){}
                            ),
                          subtitle: Text(DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
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
                        onTap: (){gotoProfile(imageList[index].ownerID);},
                          leading: imageList[index].ownerPic.contains('http') ? CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                imageList[index].ownerPic,
                                ),
                            backgroundColor: Colors.grey,
                            ) 
                            :
                            Icon(Icons.error_outline)
                            ,
                          title: GestureDetector(
                            child: Text(imageList[index].createdBy),
                            onTap: (){}
                            ),
                          subtitle: Text(DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
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
                  : ListView.builder(
                      itemCount: 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Text('Music'),
                        );
                      },
                    )),
      bottomNavigationBar: BottomAppBar(
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
