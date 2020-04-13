import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../service-locator.dart';
//model imports
import '../model/entities/globals.dart' as globals;
import '../model/entities/friend-model.dart';
import '../model/entities/user-model.dart';
import '../model/services/ifriend-service.dart';
import '../model/entities/image-model.dart';
import '../model/entities/song-model.dart';
import '../model/services/ipicture-service.dart';
import '../model/services/isong-service.dart';
import '../model/services/iuser-service.dart';
//view imports
import '../view/friends-page.dart';
import '../view/homepage.dart';
import '../view/recommend-friends-page.dart';
import '../view/time-management-page.dart';
import '../view/design-constants.dart';
import '../view/my-snapshot-page.dart';
import '../view/account-setting-page.dart';
import '../view/profile-page.dart';
import '../view/music-feed.dart';
import 'limit-reached-dialog.dart';




class MyDrawer extends StatelessWidget {
  final UserModel user;
  final BuildContext context;
  final IFriendService friendService = locator<IFriendService>();
  final ISongService _songService = locator<ISongService>();
  final IImageService _imageService = locator<IImageService>();
  final IUserService _userService = locator<IUserService>();
  final bool visit = false;
  MyDrawer(this.context, this.user);

  void navigateHomepage() async {
    List<SongModel> songlist;
    Navigator.pop(context);
    checkLimits();
  }

  void navigateProfile() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ProfilePage(user, user, visit)
    ));
    checkLimits();
  }

  void navigateSnapshotPage() async {
    List<ImageModel> imagelist;
    try {
      imagelist = await _imageService.getImage(user.email);
    } 
    catch (e) {
      imagelist = <ImageModel>[];
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SnapshotPage(user, imagelist)));
  }

  void navigateAccountSettingPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AccountSettingPage(user)));
    checkLimits();
  }


  void signOut() async {
    FirebaseAuth.instance.signOut(); //Email/pass sign out
    GoogleSignIn().signOut();
    //Display confirmation dialog box after user clicking on "Sign Out" button
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmation',
            style: TextStyle(color: DesignConstants.yellow, fontSize: 30),
          ),
          content: Text('Would you like to sign out?',
              style: TextStyle(color: DesignConstants.yellow)),
          backgroundColor: DesignConstants.blue,
          actions: <Widget>[
            RaisedButton(
              child: Text(
                'YES',
                style: TextStyle(color: DesignConstants.yellow, fontSize: 20),
              ),
              color: DesignConstants.blue,
              onPressed: () {
                //Dialog box pop up to confirm signing out
                FirebaseAuth.instance.signOut();
                globals.timer.stopTimer();
                globals.timer = null;
                globals.touchCounter = null;
                globals.limit = null;
                //Close Drawer, then go back to Front Page
                Navigator.pop(context); //Close Dialog box
                Navigator.pop(context); //Close Drawer
                Navigator.pop(context); //Close homepage return to Login
              },
            ),
            RaisedButton(
              child: Text(
                'NO',
                style: TextStyle(color: DesignConstants.yellow, fontSize: 20),
              ),
              color: DesignConstants.blue,
              onPressed: () => Navigator.pop(context), //close dialog box
            ),
          ],
        );
      },
    );
  }

  void myFriendsMenu() async {
    List<Friend> friends = await friendService.getFriends(user.friends);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FriendPage(user, friends)));
    checkLimits();
  }

  void recommendFriends() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendFriends(user),
        ));
    checkLimits();
  }

  void navigateTimeManagement() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => TimeManagementPage(user)));
    checkLimits();
  }

  void navigateMusicFeed() async {
    List<SongModel> allSongList;
    List<UserModel> allUserList;
    try {
      print("GET SONGS & USERS");
      allSongList = await _songService.getAllSongList();
      allUserList = await _userService.readAllUser();
    } catch (e) {
      allSongList = <SongModel>[];

      print("SONGLIST LENGTH: " + allSongList.length.toString());
    }
    print("SUCCEED IN GETTING SONGS & USERS");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicFeed(user, allUserList, allSongList),
      ),
    );
  }

  void checkLimits() async {
    var timeLimitReached = (globals
                .getDate(globals.limit.overrideThruDate)
                .difference(DateTime.now())
                .inDays !=
            0 &&
        globals.timer.timeOnAppSec / 60 > globals.limit.timeLimitMin);
    var touchLimitReached = (globals
                .getDate(globals.limit.overrideThruDate)
                .difference(DateTime.now())
                .inDays !=
            0 &&
        globals.touchCounter.touches > globals.limit.touchLimit);

    if ((timeLimitReached && globals.limit.timeLimitMin > 0) ||
        (touchLimitReached && globals.limit.touchLimit > 0)) {
      LimitReachedDialog.info(
          context: this.context,
          user: this.user,
          timeReached: timeLimitReached);
      print('Limit Dialog opened');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: DesignConstants.blue),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user.profilePic != null && user.profilePic != ''
                      ? user.profilePic
                      : DesignConstants.profile,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.account_circle),
                ),
              ),
            ),
            accountName: Text(user.username),
            accountEmail: Text(user.email),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Homepage'),
            onTap: navigateHomepage,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: navigateProfile,
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Time Management'),
            onTap: navigateTimeManagement,
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Friends'),
            onTap: myFriendsMenu,
          ),
          ListTile(
            leading: Icon(Icons.group_add),
            title: Text('Recommended Friends'),
            onTap: recommendFriends,
          ),
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text('Music Feed'),
            onTap: navigateMusicFeed,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Account Settings'),
            onTap: navigateAccountSettingPage,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: signOut,
          ), //Special Widget for Drawer
        ],
      ),
    );
  }
}
