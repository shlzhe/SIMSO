import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simso/view/design-constants.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/homepage-controller.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import '../model/entities/globals.dart' as globals;

class Homepage extends StatefulWidget {
  final UserModel user;

  Homepage(this.user);

  @override
  State<StatefulWidget> createState() {
    return HomepageState(user);
  }
}

class HomepageState extends State<Homepage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  HomepageController controller;
  UserModel user;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  //----------------------------------------------------
  //CREATE INSTANCES FOR GOOGLE SIGN IN 
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //----------------------------------------------------

  HomepageState(this.user) {
    controller = HomepageController(this, this.userService, this.timerService);
    controller.setupTimer();
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
            Icons.library_music,
            color: Colors.black,
          ),
          // Text(
          //   "Add Playlist",
          //   style: TextStyle(color: Colors.black),
          // ),
          onPressed: controller.addThoughts,
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
            Icons.library_music,
            color: Colors.black,
          ),
          // Text(
          //   "Add Playlist",
          //   style: TextStyle(color: Colors.black),
          // ),
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
            Icons.library_music,
            color: Colors.black,
          ),
          // Text(
          //   "Add Playlist",
          //   style: TextStyle(color: Colors.black),
          // ),
          onPressed: controller.addMemes,
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
          // Text(
          //   "Add Song",
          //   style: TextStyle(color: Colors.black),
          // ),
          onPressed: controller.addMusic,
        ),
      ),
    );

    return Scaffold(
      //backgroundColor: DesignConstants.blueGreyish,   //Body's background color
      appBar: AppBar(
        backgroundColor: DesignConstants.blue,
        title: Text('Home Page',style: TextStyle(color: DesignConstants.yellow),),
        
      ),
      floatingActionButton: UnicornDialer(
        backgroundColor: Colors.transparent,
        parentButtonBackground: Colors.blueGrey[300],
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(
          Icons.menu,
        ),
        childButtons: childButtons,
      ),
     
      body: Container(
          child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              onSaved: controller.saveEmail,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              onSaved: controller.saveUsername,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            FlatButton(
              onPressed: controller.saveUser,
              child: Text(
                'Add Data',
              ),
            ),
            Text(
              returnedID == null
                  ? ''
                  : 'The ID of your new document has returned',
              style: TextStyle(color: Colors.redAccent),
            ),
            TextFormField(
              onSaved: controller.saveUserID,
              controller: idController,
              decoration: InputDecoration(
                labelText: 'Get Customer by ID',
              ),
            ),
            FlatButton(
              onPressed: controller.getUserData,
              child: Text(
                'Get User',
              ),
            ),
            Text('User Email: ' + user.email == null ? '' : 'user.email'),
            Text('Username: ' + user.username == null ? '' : 'user.username'),
            Text(globals.timer == null ? '' : '${globals.timer.timeOnAppSec}'),
            FlatButton(
              onPressed: controller.refreshState,
              child: Text(
                'Resfresh State',
              ),
            ),
          ],
        ),
      )),


      //Create DRAWER to replace return button on HOME PAGE
        drawer: Drawer(
          child: ListView(     
            children: <Widget>[
               UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: (user.profilePic == '' || user.profilePic == null || user.profilePic.isEmpty) ? Text('No Image') : Text(''),
                  backgroundImage: (user.profilePic == '' || user.profilePic == null || user.profilePic.isEmpty) ? null : NetworkImage(user.profilePic),
                ),
                accountName: Text(user.username,style: TextStyle(fontSize: 20,fontFamily: 'Modak',color: Colors.blue),),
                accountEmail: Text(user.email,style: TextStyle(fontSize: 20,fontFamily: 'Modak',color:Colors.blue),),
                decoration: BoxDecoration(color: Colors.yellow),
              ),
              
               ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Profile'),   //Go to Profile Page
                onTap: (){},

              ),
              
              
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Friends in town'),
                onTap: (){},            //go to google map display friends as markers around the user

              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: controller.signOut,
              ),    //Special Widget for Drawer

            ],
          )
        ),


    );
  }
}
