import 'package:simso/model/entities/friend-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ifriend-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendService extends IFriendService {
  static const FriendRequest = "friendrequest";

  List<UserModel> userList = new List<UserModel>();
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      var query = await Firestore.instance
          .collection(UserModel.USERCOLLECTION)
          .getDocuments();

      if (query.documents.isEmpty) {
        return null;
      } else {
        query.documents
            .forEach((doc) => {userList.add(UserModel.deserialize(doc.data))});
        return userList;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void addFriendRequest(UserModel currentUser, UserModel friendUser) async {
    var emptyList = <String>[];
    try {
      //This section is to make UserModel compatible with new added elements
      // begin of compatibility
      await Firestore.instance
          .collection(UserModel.USERCOLLECTION)
          .document(currentUser.uid).get().then((value) async {
            if(!value.data.containsValue(UserModel.FRIENDREQUESTSENT)){
              await Firestore.instance.collection(UserModel.USERCOLLECTION).document(currentUser.uid).updateData({
                UserModel.FRIENDREQUESTSENT: emptyList
              });
            } 
            if(!value.data.containsValue(UserModel.FRIENDREQUESTRECIEVED)){
              await Firestore.instance.collection(UserModel.USERCOLLECTION).document(currentUser.uid).updateData({
                UserModel.FRIENDREQUESTRECIEVED: emptyList
              });
            }
          });
      await Firestore.instance
          .collection(UserModel.USERCOLLECTION)
          .document(friendUser.uid).get().then((value) async {
            if(!value.data.containsValue(UserModel.FRIENDREQUESTSENT)){
              await Firestore.instance.collection(UserModel.USERCOLLECTION).document(friendUser.uid).updateData({
                UserModel.FRIENDREQUESTSENT: emptyList
              });
            } 
            if(!value.data.containsValue(UserModel.FRIENDREQUESTRECIEVED)){
              await Firestore.instance.collection(UserModel.USERCOLLECTION).document(friendUser.uid).updateData({
                UserModel.FRIENDREQUESTRECIEVED: emptyList
              });
            }
          });
      // end of compatibility

      
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> checkFriendRequest(UserModel currentUser, UserModel friendUser) async {
    try {
      var document =  await Firestore.instance
          .collection(FriendRequest)
          .document(currentUser.uid)
          .collection(friendUser.uid)
          .document(friendUser.email)
          .get();
      if(document.exists){
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Friend>> getFriends(List friendList) async {
    if (friendList.isEmpty)
     return new List<Friend>();

    var friends = <Friend>[];
    for (var friendId in friendList) {
      try {

        DocumentSnapshot documentSnapshot = await Firestore.instance
          .collection(UserModel.USERCOLLECTION)     
          .document(friendId)
          .get();
        
        if (documentSnapshot == null) {
          return friends;
        } 
        friends.add(Friend.deserialize(documentSnapshot.data));
      } catch(e) {
        throw e;
      }
    }
    print(friends[0].profilePic);
    return friends;
  }
}
