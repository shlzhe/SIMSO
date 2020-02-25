import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ifriend-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendService extends IFriendService {
  UserModel userModel;
  @override
  Future getFriend() async {
    try{
        var query = await Firestore.instance.collection(UserModel.UserCollection)
        .getDocuments();
        if(query.documents.isEmpty){
          return null;
        } else {
          return query.documents;
        }
        
    } catch (e){
      print(e);
      return null;
    }
  }

}