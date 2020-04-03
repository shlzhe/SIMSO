import 'package:simso/model/entities/user-model.dart';

class Friend {
  String uid;
  String username;
  String aboutme;
  String profilePic;
  String city;

Friend({this.uid, this.username, this.aboutme, this.profilePic, this.city});

 static Friend deserialize(Map<String, dynamic> document){
    return Friend(
      username: document[UserModel.USERNAME],
      aboutme: document[UserModel.ABOUTME],
      uid: document[UserModel.UID],
      profilePic: document[UserModel.PROFILEPIC],
      city: document[UserModel.CITY],
    );
  }
}