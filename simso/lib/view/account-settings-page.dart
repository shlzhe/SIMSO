import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart'; //for currentuser & google signin instance
import '../model/entities/user-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'add-photo-page.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

final auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();
final ref = Firestore.instance.collection('users');
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


class AccountSettingsPage extends StatelessWidget {
  final UserModel user;
  AccountSettingsPage(this.user);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  changeProfilePhoto(BuildContext parentContext) {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Photo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Changing your profile photo has not been implemented yet'),
              ],
            ),
          ),
        );
      },
    );
  }

  applyChanges() {
    Firestore.instance.collection('users').document(user.uid).updateData({
      "userName": nameController.text,
      "aboutMe": bioController.text,
    });
  }

  Widget buildTextField({String name, TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            name,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: name,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance
            .collection('insta_users')
            .document(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          //UserModel user = UserModel.fromDocument(snapshot.data);

          nameController.text = user.username;
          bioController.text = user.aboutme;

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                  radius: 50.0,
                ),
              ),
              FlatButton(
                  onPressed: () {
                    changeProfilePhoto(context);
                  },
                  child: Text(
                    "Change Photo",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    buildTextField(name: "Name", controller: nameController),
                    buildTextField(name: "Bio", controller: bioController),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MaterialButton(
                      onPressed: () => {_logout(context)},
                      child: Text("Logout")))
            ],
          );
        });
  }

  void _logout(BuildContext context) async {
    print("logout");
    await auth.signOut();
    await googleSignIn.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    //user = null;

    Navigator.pop(context);
  }
}
