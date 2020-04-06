import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import '../entities/user-model.dart';
import '../entities/api-constants.dart';
import 'iuser-service.dart';

// The implimentation of IUserService.
// Here we make the actual call to the database
class UserService extends IUserService {
  // This is the subsection of the API we need to call
  String url = APIConstants.BaseAPIURL + '/users';

  @override
  Future<String> login(UserModel user) async {
    try {
      AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      return auth.user.uid;
    } catch (error) {
      print(error);
      return error;
    }
  }

  @override
  Future<UserModel> readUser(String id) async {
    try {
      var query = await Firestore.instance
          .collection(UserModel.USERCOLLECTION)
          .where(UserModel.UID, isEqualTo: id)
          .getDocuments();
      if (query.documents.isEmpty)
        return null;
      else {
        return UserModel.deserialize(query.documents.first.data);
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Future<List<UserModel>> readAllUser() async {
    try {
      var query = await Firestore.instance
          .collection(UserModel.USERCOLLECTION)
          .getDocuments();
      var userList = <UserModel>[];
      if (query.documents.isEmpty || query == null || query.documents.length == 0)
        return userList;
     for (DocumentSnapshot doc in query.documents) {
       userList.add(UserModel.deserialize(doc.data));
     }

     return userList;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<String> createAccount(UserModel user) async {
    try {
      AuthResult auth = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password);
      return auth.user.uid;
    } catch (error) {
      return error;
    }
  }

  @override
  void createUserDB(UserModel user) async {
    await Firestore.instance
        .collection(UserModel.USERCOLLECTION)
        .document(user.uid)
        .setData(user.serialize());
  }

  @override
  Future<void> updateUserDB(UserModel user) async {
    await Firestore.instance
        .collection(UserModel.USERCOLLECTION)
        .document(user.uid)
        .setData(user.serialize());
  }

  @override
  void changePassword(UserModel user, String password) async {
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  @override
  void deleteUser(UserModel user) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete().then((_) {
      print("Succesfull deleted user");
    }).catchError((error) {
      print("User can't be deleted" + error.toString());
    });
    await Firestore.instance
        .collection(UserModel.USERCOLLECTION)
        .document(user.uid)
        .delete();
  }

  @override
  Future<List<dynamic>> readQuestion() async {
    List<dynamic> questions;
    var doc = await Firestore.instance.collection('Questions')
      .where('Questions')
      .getDocuments();
    doc.documents.forEach((element) {questions = element.data.values.first;});
    return questions;
  }

  @override
  Future<List<dynamic>> answerQuestion(String email) async{
    var doc = await Firestore.instance.collection('Answers')
    .where('email', isEqualTo: email)
    .getDocuments();
    if (doc.documents.isNotEmpty) return doc.documents.first.data.values.first;
    else return [];
  }

  @override
  Future<String> friendthoughts(String uid) async {
    var doc = await Firestore.instance.collection('thoughts')
      .where('uid', isEqualTo: uid)
      .getDocuments();
    String thoughts = doc.documents.first.data.values.toString();
    print(thoughts +'userfunction');
    return thoughts[2];
  }

  @override
  Future<List<UserModel>> readUsername() async{
    List<UserModel> userList=[];
    var doc = await Firestore.instance.collection(UserModel.USERCOLLECTION)
      .getDocuments();
    try{
      doc.documents.forEach((element) {
        UserModel user = UserModel.deserialize(element.data);
        userList.add(user);
      });
      return userList;
    }catch(error){
      return userList=[];
    }
  }

  
}
