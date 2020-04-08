import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/dictionary-word-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'idictionary-service.dart';

class DictionaryService extends IDictionaryService {
  Future<void> updateDictionary(
      Thought thought, SongModel song, ImageModel image) async {
    //retreive dictionary
    List<DictionaryWord> dictionaryWordList = await getDictionary();

    //parse thought text
    if (thought != null) {
      var thoughtWordList = thought.text
          .replaceAll(new RegExp(r"[^\'\w\s]+"), '')
          .replaceAll(new RegExp(r'[ ]{2,}'), ' ')
          .split(' ')
          .toSet();

      //compare existing dictionary with thought text
      var matched = false;
      var newWordDocID;
      thoughtWordList.forEach((word) async => {
            word = word.toLowerCase(),
            matched = false,
            if (dictionaryWordList != null)
              {
                dictionaryWordList.forEach((doc) async => {
                      if (word == doc.word.toLowerCase())
                        {
                          matched = true,
                          updateDictionaryWord(doc, thought, null, null)
                        }
                    }),
              },
            if (!matched) addDictionaryWord(word, thought, null, null)
          });
    }
  }

  Future<void> updateDictionaryWord(DictionaryWord word, Thought thought,
      SongModel song, ImageModel image) async {
    var duplicateThought = false;
    var duplicateSong = false;
    var duplicateImage = false;

    //if a new thought is associated with this word, 
    //check to see if the list is empty, if so, add, 
    //otherwise check for duplicate
    if (thought != null) {
      if(word.thoughtList == null || word.thoughtList.length == 0){
        word.thoughtList = [thought.thoughtId];
        duplicateThought = true;
      } else {
      word.thoughtList.forEach((n) => {
            if (n == thought.thoughtId) duplicateThought = true,
          });
      }
      if (!duplicateThought) word.thoughtList.add(thought.thoughtId);
    }

//if a new song is associated with this word, 
    //check to see if the list is empty, if so, add, 
    //otherwise check for duplicate, if not, add
    if (song != null) {
      if(word.songList == null || word.songList.length == 0){
        word.songList = [song.songId];
        duplicateSong = true;
      }else {
      word.songList.forEach((n) => {
            if (n == song.songId) duplicateSong = true,
          });
      }
      if (!duplicateSong) word.songList.add(song.songId);
    }

//if a new image is associated with this word, 
    //check to see if the list is empty, if so, add, 
    //otherwise check for duplicate
    if (image != null) {
      if(word.imageList == null || word.imageList.length == 0){
        word.imageList = [image.imageId];
        duplicateImage = true;
      }else {
      word.imageList.forEach((n) => {
            if (n == image.imageId) duplicateImage = true,
          });
      }
      if (!duplicateImage) word.imageList.add(image.imageId);
    }

    if (!duplicateThought || !duplicateSong || !duplicateImage) {
      word.usage.add(DateTime.now());
      word.useCount++;
      await Firestore.instance
          .collection(DictionaryWord.DICTIONARY_COLLECTION)
          .document(word.wordDocID)
          .setData(word.serialize());
    }
  }

  Future<void> addDictionaryWord(
      String text, Thought thought, SongModel song, ImageModel image) async {
    var newWord = DictionaryWord.empty();
    
    newWord.word = text;
    newWord.useCount = 1;
    newWord.isKeyword = true;
    newWord.usage.add(DateTime.now());
    if(thought != null) newWord.thoughtList.add(thought.thoughtId);
    if(song != null) newWord.songList.add(song.songId);
    if(image != null) newWord.imageList.add(image.imageId);  

    DocumentReference ref = await Firestore.instance
        .collection(DictionaryWord.DICTIONARY_COLLECTION)
        .add(newWord.serialize());

    //return ref.documentID.toString();
  }

  Future<void> deleteDictionaryWord(String docID) async {
    await Firestore.instance
        .collection(DictionaryWord.DICTIONARY_COLLECTION)
        .document(docID)
        .delete();
  }
  @override
  Future<List<String>> getMyKeywords(String thoughtId, String songId, String imageId) async {
      var myKeywords = <String>[];
      QuerySnapshot querySnapshot;
      var duplicate = false;
      var keyword;

      try{
          querySnapshot = await Firestore.instance
          .collection(DictionaryWord.DICTIONARY_COLLECTION)
          .where(DictionaryWord.THOUGHTLIST, arrayContains: thoughtId)
          .getDocuments();
          if (querySnapshot == null || querySnapshot.documents.length == 0) print('querysnapshot is null');
          for (DocumentSnapshot doc in querySnapshot.documents) {
            keyword = DictionaryWord.deserialize(doc.data, doc.documentID).word;
            duplicate = false;
            if(myKeywords.isEmpty){
              myKeywords.add(DictionaryWord.deserialize(doc.data, doc.documentID).word);
              duplicate = true;
            } else {
              myKeywords.forEach((n) => {if(n == keyword) duplicate == true});
            };
            if(!duplicate)
            myKeywords.add(DictionaryWord.deserialize(doc.data, doc.documentID).word);
          }
      } catch(e){
        throw e;
      }
    return myKeywords;
  }

  @override
  Future<List<DictionaryWord>> getDictionary() async {
    print("Firebase thought-service.dart getDictionary() called");
    try {
      var dictionaryWordList = <DictionaryWord>[];
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(DictionaryWord.DICTIONARY_COLLECTION)
          .getDocuments();

      for (DocumentSnapshot doc in querySnapshot.documents) {
        dictionaryWordList
            .add(DictionaryWord.deserialize(doc.data, doc.documentID));
      }
      return dictionaryWordList;
    } catch (e) {
      throw e;
    }
  }
}
