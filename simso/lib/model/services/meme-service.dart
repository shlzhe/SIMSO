import 'package:simso/model/entities/meme-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/service-locator.dart';
import 'imeme-service.dart';

class MemeService extends IMemeService {
  //IDictionaryService _dictionaryService = locator<IDictionaryService>();

  @override
  Future<Meme> addMeme(Meme meme) async {

    await Firestore.instance.collection(Meme.MEMES_COLLECTION)
      .add(meme.serialize())
      .then((docRef) {
            print(docRef.documentID);
          print('~~~~~~~~~~~~~~~~~~~~~~~');
        meme.memeId = docRef.documentID;
      })
      .catchError((onError) {
        print(onError);
        return onError.toString();
      }
      );
  }

  @override
  Future<void> updateMeme(Meme meme) async {
    await Firestore.instance
        .collection(Meme.MEMES_COLLECTION)
        .document(meme.memeId)
        .setData(meme.serialize());
    //return ref.documentID;
  }

  @override
  Future<List<Meme>> getMemes(String uid) async {
    var myMemesList = <Meme>[]; // empty list
    try {
      QuerySnapshot queryMeme = await Firestore.instance
          .collection(Meme.MEMES_COLLECTION)
          .where(Meme.OWNERID, isEqualTo: uid)
           .orderBy(Meme.TIMESTAMP)
          .getDocuments();
      if (queryMeme == null || queryMeme.documents.length == 0) {
        return myMemesList;
      }
      for (DocumentSnapshot doc in queryMeme.documents) {
        myMemesList.add(Meme.deserialize(doc.data, doc.documentID));
      }
      return myMemesList;
    } catch (e) {
      return myMemesList; //empty list
    }
  }

  Future<void> deleteMeme(String docID) async {
    try{
    await Firestore.instance
        .collection(Meme.MEMES_COLLECTION)
        .document(docID)
        .delete();
    } catch (e){
      throw e;
    }

  }

  @override
  Future<List<Meme>> contentMemeList(bool friends, UserModel user) async {
    var data = <Meme>[];
    var friendsMemeList = <Meme>[];
    try {
      QuerySnapshot queryMeme = await Firestore.instance
          .collection(Meme.MEMES_COLLECTION)
          .orderBy(Meme.TIMESTAMP)
          .getDocuments();
      for (DocumentSnapshot doc in queryMeme.documents) {
        data.add(Meme.deserialize(doc.data, doc.documentID));
      }
      data.removeWhere((element) => element.ownerID==user.uid.toString());
      if(!friends){ //new content remove friends content
        try{
          for (var i in user.friends){
            data.removeWhere((element) => element.ownerID==i.toString());
          }
        }catch(error){print(error);}
        return data;
      }
      else{
        try{
          for (var i in user.friends){//friends content remove public content
            var temp = data.where((element) => element.ownerID==i.toString());
            friendsMemeList.addAll(temp);
          }
        }catch(error){print(error);}
      }
      return friendsMemeList;
    }catch(error){
      return data;
    }
  }
}
