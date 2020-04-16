
import 'package:simso/model/entities/friend-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/entities/friendRequest-model.dart';
import 'package:simso/view/friends-page.dart';


abstract class IFriendService {
  Future<List<UserModel>> getUsers();
  void addFriendRequest(UserModel currentUser,UserModel friendUser);
  Future<bool> checkFriendRequest(UserModel currentUser, UserModel friendUser);
  Future<List<Friend>> getFriends(List<dynamic> friendList);
  Future<List<FriendRequests>> getFriendRequests(List<dynamic> friendRequestList);
   void addFriend(UserModel currentUser, FriendRequests friendUser);
    void declineFriend(UserModel currentUser, FriendRequests friendUser);
   void deleteFriend(UserModel currentUser, Friend friendUser);
  
}