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
    try {
      await Firestore.instance
          .collection(FriendRequest)
          .document(currentUser.uid)
          .collection(friendUser.uid)
          .document(friendUser.email)
          .setData(friendUser.serialize());
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
}
