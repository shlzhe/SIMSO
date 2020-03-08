import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    try{
      AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email, password: user.password);
      return auth.user.uid;
    }
    catch(error){
      print(error);
      return error;
    }
  }

  @override
  Future<UserModel> readUser(String id) async{
    try{
      var query = await Firestore.instance.collection(UserModel.USERCOLLECTION)
        .where(UserModel.UID, isEqualTo: id)
        .getDocuments();
      if (query.documents.isEmpty) return null;
      else{
        return UserModel.deserialize(query.documents.first.data);
      }
    }
    catch(error){
      print(error);
      return null;
    }
  }

  @override
  Future<String> createAccount(UserModel user) async {
    try{
      AuthResult auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password);
      return auth.user.uid;
    }
    catch(error){
      return error;
    }
  }

  @override
  void createUserDB(UserModel user) async{
    await Firestore.instance.collection(UserModel.USERCOLLECTION)
      .document(user.uid)
      .setData(user.serialize());
  }

    @override
  void updateUserDB(UserModel user) async{
    await Firestore.instance.collection(UserModel.USERCOLLECTION)
      .document(user.uid)
      .setData(user.serialize());
  }
}