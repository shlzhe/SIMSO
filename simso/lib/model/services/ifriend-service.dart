
import 'package:simso/model/entities/friend-model.dart';
import 'package:simso/model/entities/user-model.dart';

abstract class IFriendService {
  Future<List<UserModel>> getUsers();
  void addFriendRequest(UserModel currentUser,UserModel friendUser);
  Future<bool> checkFriendRequest(UserModel currentUser, UserModel friendUser);
  Future<List<Friend>> getFriends(List<dynamic> friendList);
}