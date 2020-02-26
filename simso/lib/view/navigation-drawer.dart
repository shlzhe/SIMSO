import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/homepage.dart';
import 'package:simso/view/login-page.dart';
import 'package:simso/view/time-management-page.dart';

import 'design-constants.dart';

class MyDrawer extends StatelessWidget {
  final UserModel user;
  final BuildContext context;

  MyDrawer(this.context, this.user);





  void navigateHomepage() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Homepage(user)
    ));
  }

  void signOut(){  
    FirebaseAuth.instance.signOut();      //Email/pass sign out  
    
    //this.googleSignIn.signOut();          //Google sign out
     //Display confirmation dialog box after user clicking on "Sign Out" button
    showDialog (
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Confirmation',style: TextStyle(color: DesignConstants.yellow,fontSize: 30),),
          content: Text('Would you like to sign out?', style: TextStyle(color: DesignConstants.yellow)) ,
          backgroundColor: DesignConstants.blue,
          actions: <Widget>[
            RaisedButton(
              child: Text('YES', style: TextStyle(color: DesignConstants.yellow,fontSize: 20),),
              color: DesignConstants.blue,
              onPressed: (){
                //Dialog box pop up to confirm signing out
                FirebaseAuth.instance.signOut();     
                //Close Drawer, then go back to Front Page
                Navigator.pop(context);  //Close Dialog box
                Navigator.pop(context);  //Close Drawer
                //Navigator.pop(state.context);  //Close Home Page 
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> LoginPage(),
                ));
              },
            ),
            RaisedButton(
              child: Text('NO', style: TextStyle(color: DesignConstants.yellow, fontSize: 20),),
              color: DesignConstants.blue,
              onPressed: ()=>Navigator.pop(context),  //close dialog box 
            ),
          ],
        );
        
      },
    );
  }


  void navigateTimeManagement() async {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => TimeManagementPage(user)
    ));
  }

  //  GOOGLE SIGN IN 
  


 //----------------------------------------------------------------


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
                  imageUrl: user.profilePic != null &&
                            user.profilePic != ''
                      ? user.profilePic
                      : DesignConstants.profile,
                  placeholder: (context, url) =>
                      CircularProgressIndicator(),
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
            leading: Icon(Icons.timer),
            title: Text('Time Management'),
            onTap: navigateTimeManagement,
          ),
          ListTile(
            leading: Icon(Icons.bubble_chart),
            title: Text('My Thoughts'),
          ),
           ListTile(
            leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: signOut,
              ),    //Special Widget for Drawer
        ],
      ),
    );
  }
}