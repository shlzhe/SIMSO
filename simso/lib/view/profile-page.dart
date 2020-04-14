import 'package:flutter/material.dart';
import 'package:simso/view/design-constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/entities/user-model.dart';
import '../controller/profile-page-controller.dart';

import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/meme-model.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import 'package:simso/model/services/ipicture-service.dart';
import 'package:simso/model/services/itouch-service.dart';

import 'package:simso/controller/homepage-controller.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../service-locator.dart';
import 'design-constants.dart';

import 'package:simso/model/services/ifriend-service.dart';


class ProfilePage extends StatefulWidget {
  
  final UserModel currentUser;
  final UserModel visitUser;
  final bool visit;

  ProfilePage(this.currentUser, this.visitUser,this.visit);

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(currentUser, visitUser, visit);
  }
}

class ProfilePageState extends State<ProfilePage> {
  UserModel currentUser;
  UserModel visitUser;
  UserModel ogUser;
  bool visit;
  ProfilePageController controller;
  var formKey = GlobalKey<FormState>();
  BuildContext context;

  // IUserSice imageService = locator<IImageService>();
  // final IFriendService friendService = locator<IFriendService>();
  bool meme = false;
  bool music = false;
  bool snapshots = false;
  bool thoughts = false;
  bool friends = true;
  // List<Thought> publicThoughtsList = [];


  //List<UserModel> visitUser; I don't think this is used as a list
  List<ImageModel> imageList =[];
  List<SongModel> songlist;
  List<Meme> memesList;
  String returnedID;
  var idController = TextEditingController();
  // var formKey = GlobalKey<FormState>();

  ProfilePageState(this.currentUser, this.visitUser, this.visit) {
    controller = ProfilePageController(this, this.currentUser, this.visitUser);

  }

  void stateChanged(Function fn) {
    setState(fn);
  }

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(visitUser.username + "'s Profile"),
        backgroundColor: DesignConstants.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
            onPressed: controller.mainChatScreen,
          ),
          visit == false
              ? IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: controller.accountSettings,
                )
              : Container(),
        ],
      ),
      // drawer: MyDrawer(context, user),
      body: ListView(children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          width: 70,
          height: 120,
          child: CachedNetworkImage(
            imageUrl: visitUser.profilePic != null && visitUser.profilePic != ''
                ? visitUser.profilePic
                : DesignConstants.profile,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.account_circle),
          ),
        ),
        Text(
          'My Profile',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Text(''),
        Text(
          'Email: ' + visitUser.email,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Text(
          'Username: ' + visitUser.username,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        if (visitUser.age == 0)
          Text(
            'Age: ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: (TextAlign.center),
          ),
        if (visitUser.age != 0)
          Text(
            'Age: ' + visitUser.age.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: (TextAlign.center),
          ),
        visitUser.gender != null
            ? Text(
                'Gender: ' + visitUser.gender,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: (TextAlign.center),
              )
            : Text(
                'Gender: Uavailable',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: (TextAlign.center),
              ),
        Text(
          'City: ' + visitUser.city,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        Text(
          'Bio: ' + visitUser.aboutme,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: (TextAlign.center),
        ),
        SizedBox(
          height: 20,
        ),
        // ButtonTheme(
        //   minWidth: 100,
        //   height: 60,
        //   buttonColor: DesignConstants.blue,
        //   child: Container(
        //     padding: EdgeInsets.only(
        //       left: 30,
        //       right: 30,
        //     ),
        //     child: RaisedButton(
        //       child: Text(
        //         'My Music',
        //         style: TextStyle(
        //           fontSize: 40,
        //           color: DesignConstants.yellow,
        //         ),
        //       ),
        //       onPressed: controller.mymusic,
        //     ),
        //   ),
        // )
      ]),
      
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: DesignConstants.blue,
        currentIndex: _selectedIndex,
        selectedItemColor: DesignConstants.blue,
        onTap: controller.goTo,
          type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            title: Text('My Thoughts'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_size_select_actual),
            title: Text('My Memes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            title: Text('My Snapshots'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            title: Text('My Music'),
          ),
        ],
      ),
    );
  }
}
