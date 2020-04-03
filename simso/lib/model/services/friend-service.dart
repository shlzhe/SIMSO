import 'package:simso/model/entities/friend-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ifriend-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/friendRequest-model.dart' ;
import 'package:simso/model/services/ifriend-service.dart';


class FriendService extends IFriendService {
  static const FriendRequest = "friendrequest";

  @override
  Future<List<UserModel>> getUsers() async {
    List<UserModel> userList = new List<UserModel>();
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
            if(!value.data.containsKey(UserModel.FRIENDREQUESTSENT)){
              await Firestore.instance.collection(UserModel.USERCOLLECTION).document(currentUser.uid).updateData({
                UserModel.FRIENDREQUESTSENT: emptyList
              });
            } 
            if(!value.data.containsKey(UserModel.FRIENDREQUESTRECIEVED)){
              await Firestore.instance.collection(UserModel.USERCOLLECTION).document(currentUser.uid).updateData({
                UserModel.FRIENDREQUESTRECIEVED: emptyList
              });
            }
          });
      await Firestore.instance
          .collection(UserModel.USERCOLLECTION)
          .document(friendUser.uid).get().then((value) async {
            if(!value.data.containsKey(UserModel.FRIENDREQUESTSENT)){
              await Firestore.instance.collection(UserModel.USERCOLLECTION).document(friendUser.uid).updateData({
                UserModel.FRIENDREQUESTSENT: emptyList
              });
            } 
            if(!value.data.containsKey(UserModel.FRIENDREQUESTRECIEVED)){
              await Firestore.instance.collection(UserModel.USERCOLLECTION).document(friendUser.uid).updateData({
                UserModel.FRIENDREQUESTRECIEVED: emptyList
              });
            }
          });
      // end of compatibility

      //user sent friend request
      await Firestore.instance.collection(UserModel.USERCOLLECTION).document(currentUser.uid).updateData({
        UserModel.FRIENDREQUESTSENT: FieldValue.arrayUnion([friendUser.uid])
      });

      //user recieve friend request
      await Firestore.instance.collection(UserModel.USERCOLLECTION).document(friendUser.uid).updateData({
        UserModel.FRIENDREQUESTRECIEVED: FieldValue.arrayUnion([currentUser.uid])
      });
        
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> checkFriendRequest(UserModel currentUser, UserModel friendUser) async {
    try {
      var document =  await Firestore.instance
          .collection(UserModel.USERCOLLECTION + currentUser.uid)
          .where(UserModel.FRIENDREQUESTSENT, isEqualTo: friendUser.uid)
          .getDocuments();
      if(document.documents.isEmpty){
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

  

  @override
  Future<List<FriendRequests>> getFriendRequests(List friendRequestList) async {
  
    if (friendRequestList.isEmpty)
     return new List<FriendRequests>();

    var friendRequests = <FriendRequests>[];
    
    for (var friendRequestId in friendRequestList) {
      try {

        DocumentSnapshot documentSnapshot = await Firestore.instance
          .collection(UserModel.USERCOLLECTION)     
          .document(friendRequestId)
          .get();
      //  print(friendRequestList);
        if (documentSnapshot == null) {
          return friendRequests;
        } 
        friendRequests.add(FriendRequests.deserialize(documentSnapshot.data));
        
      } catch(e) {
        throw e;
      }
      
    }
    print(friendRequestList);
  return friendRequests;
  
  }


  @override
  void addFriend(UserModel currentUser, FriendRequests friendUser) async {  
        try{       
     await Firestore.instance.collection(UserModel.USERCOLLECTION).document(currentUser.uid).updateData({
          UserModel.FRIENDS: FieldValue.arrayUnion([friendUser.uid])
          });
       } catch (e) {
          print(e);
        }
        await Firestore.instance.collection(UserModel.USERCOLLECTION).document(currentUser.uid).updateData({
          UserModel.FRIENDREQUESTRECIEVED: FieldValue.arrayRemove([friendUser.uid])
        });
          }
        

     @override
  void declineFriend(UserModel currentUser, FriendRequests friendUser) async {  
        try{       
     await Firestore.instance.collection(UserModel.USERCOLLECTION).document(currentUser.uid).updateData({
          UserModel.FRIENDREQUESTRECIEVED: FieldValue.arrayRemove([friendUser.uid])
          });
       } catch (e) {
          print(e);
        }   
  }

 @override
  void deleteFriend(UserModel currentUser, UserModel friendUser) async {  
        try{       
     await Firestore.instance.collection(UserModel.USERCOLLECTION).document(currentUser.uid).updateData({
          UserModel.FRIENDS: FieldValue.arrayRemove([friendUser.uid])
          });
       } catch (e) {
          print(e);
        }   
  }


}



