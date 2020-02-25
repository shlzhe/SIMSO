import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/entities/song-model.dart';


class FirebaseFunctions{

  static Future<String> login(String email, String password) async{
    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return auth.user.uid;
  }
  // create account
  static Future <String> createAccount(String email, String password)async{
    AuthResult auth = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return auth.user.uid;
  }
  // create user database
  static void createProfile(UserModel user) async {
    await Firestore.instance.collection(UserModel.UserCollection)
      .document(user.uid)
      .setData(user.serialize());
  }
  // read user into android
  static Future<UserModel> readUser(String uid) async{
    DocumentSnapshot doc = await Firestore.instance.collection(UserModel.UserCollection)
      .document(uid)
      .get();
    return UserModel.deserialize(doc.data);
  }

  static Future<String> addSong(SongModel song) async {
    // save it from firstore instance
    // collection name is Song.SONG_COLLECTION
    // add function after serialized data
    // returns document reference type
    DocumentReference ref = await Firestore.instance
        .collection(SongModel.SONG_COLLECTION)
        .add(song.serialize());
    return ref.documentID;
  }
}