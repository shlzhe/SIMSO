import 'package:simso/model/entities/meme-model.dart';
import 'package:simso/model/entities/dictionary-word-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/service-locator.dart';
import 'imeme-service.dart';
//import 'idictionary-service.dart';

class MemeService extends IMemeService {
  //IDictionaryService _dictionaryService = locator<IDictionaryService>();

  @override
  Future<void> addMeme(Meme meme) async {

    await Firestore.instance.collection(Meme.MEMES_COLLECTION)
      .add(meme.serialize())
      .then((docRef) {
        meme.memeId = docRef.documentID;
      })
      .catchError((onError) {
        print(onError);
        return null;
      });
    
   // _dictionaryService.updateDictionary(null, null, null);
  }

  @override
  Future<void> updateMeme(Meme meme) async {
    await Firestore.instance
        .collection(Meme.MEMES_COLLECTION)
        .document(meme.memeId)
        .setData(meme.serialize());
    //return ref.documentID;
    //get dictionary

   // _dictionaryService.updateDictionary(null, null, null);
  }

  @override
  Future<List<Meme>> getMemes(String uid) async {
    try {
      QuerySnapshot queryMeme = await Firestore.instance
          .collection(Meme.MEMES_COLLECTION)
          .where(Meme.UID, isEqualTo: uid)
          .orderBy(Meme.TIMESTAMP)
          .getDocuments();
      var myMemesList = <Meme>[];
      

      if (queryMeme == null || queryMeme.documents.length == 0) {
        return myMemesList;
      }
      for (DocumentSnapshot doc in queryMeme.documents) {
        myMemesList.add(Meme.deserialize(doc.data, doc.documentID));
      }
      return myMemesList;
    } catch (e) {
      throw e;
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
  Future<List<Meme>> contentMemeList(bool friends, List<dynamic> friendslist) async {
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
      if(!friends){ //new content remove friends content
        try{
          for (var i in friendslist){
            data.removeWhere((element) => element.uid==i.toString());
          }
        }catch(error){print(error);}
        return data;
      }
      else{
        try{
          for (var i in friendslist){//friends content remove public content
            var temp = data.where((element) => element.uid==i.toString());
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
