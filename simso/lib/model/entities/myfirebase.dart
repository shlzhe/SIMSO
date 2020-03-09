import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/user-model.dart';

class MyFirebase{
  static Future<List<UserModel>> getUsers() async{

    QuerySnapshot querySnapshot = await Firestore.instance.collection('users')
      .getDocuments();
    var userList = <UserModel>[];
    if (querySnapshot == null || querySnapshot.documents.length ==0){
      print('Empty userList');
      return userList;
    }
    for (DocumentSnapshot doc in querySnapshot.documents){
      print('Users Collection is not empty');
      userList.add(UserModel.deserialize(doc.data));
    }

    return userList;

    }
  }
