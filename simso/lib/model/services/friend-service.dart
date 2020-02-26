import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ifriend-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendService extends IFriendService {
  UserModel userModel;

  List<UserModel> friendList = new List<UserModel>();
  @override
  Future<List<UserModel>> getUsers() async {
    try{
        var query = await Firestore.instance.collection(UserModel.UserCollection)
        .getDocuments();

        if(query.documents.isEmpty){
          return null;
        } else {
          query.documents.forEach((doc)=>{
            friendList.add(UserModel.deserialize(doc.data))
          });
          return friendList;
        }
    } catch (e){
      print(e.toString());
      return null;
    }
  }

}