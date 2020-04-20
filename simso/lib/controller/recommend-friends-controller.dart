import 'package:flutter/material.dart';
import 'package:simso/model/entities/user-model.dart';
import '../view/recommend-friends-page.dart';
import '../view/profile-page.dart';
import '../model/entities/user-model.dart';
import '../model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';

class RecommendFriendsController {
  final UserModel currentUser;

  BuildContext context;
  RecommendFriendsState state;
  List<UserModel> userList;
  UserModel newUser = UserModel();
  final IUserService _userService = locator<IUserService>();

  RecommendFriendsController(this.state, this.currentUser);
  
  void viewProfile(String uid) async {
    UserModel visitUser = await _userService.readUser(uid);
    await Navigator.push(
      state.context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(state.currentUser, visitUser, true),
        ));
    Navigator.pop(state.context);
  }
  
}