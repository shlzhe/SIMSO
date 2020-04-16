import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/dictionary-word-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'idictionary-service.dart';

class DictionaryService extends IDictionaryService {
  Future<void> updateDictionary(Thought thought) async {
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

      thoughtWordList.forEach((word) async => {
            word = word.toLowerCase(),
            matched = false,
            if (dictionaryWordList != null)
              {
                dictionaryWordList.forEach((doc) async => {
                      if (word == doc.word.toLowerCase())
                        {matched = true, updateDictionaryWord(doc, thought)}
                    }),
              },
            if (!matched) addDictionaryWord(word, thought)
          });
    }
  }

  Future<void> updateDictionaryWord(
      DictionaryWord word, Thought thought) async {
    var duplicateThought = false;

    //if a new thought is associated with this word,
    //check to see if the list is empty, if so, add,
    //otherwise check for duplicate
    if (thought != null) {
      if (word.thoughtList == null || word.thoughtList.length == 0) {
        word.thoughtList = [thought.thoughtId];
        duplicateThought = true;
      } else {
        word.thoughtList.forEach((n) => {
              if (n == thought.thoughtId) duplicateThought = true,
            });
      }
      if (!duplicateThought) word.thoughtList.add(thought.thoughtId);
    }

    if (!duplicateThought) {
      word.usage.add(DateTime.now());
      word.useCount++;
      await Firestore.instance
          .collection(DictionaryWord.DICTIONARY_COLLECTION)
          .document(word.wordDocID)
          .setData(word.serialize());
    }
  }

  Future<void> addDictionaryWord(String text, Thought thought) async {
    var newWord = DictionaryWord.empty();

    newWord.word = text;
    newWord.useCount = 1;
    newWord.isKeyword = true;
    newWord.usage.add(DateTime.now());
    if (thought != null) newWord.thoughtList.add(thought.thoughtId);

    await Firestore.instance
        .collection(DictionaryWord.DICTIONARY_COLLECTION)
        .add(newWord.serialize());
  }

  Future<void> deleteDictionaryWord(String docID) async {
    await Firestore.instance
        .collection(DictionaryWord.DICTIONARY_COLLECTION)
        .document(docID)
        .delete();
  }

  @override
  Future<List<String>> getMyKeywords(String thoughtId) async {
    var myKeywords = <String>[];
    QuerySnapshot querySnapshot;
    var duplicate = false;
    var keyword;

    try {
      querySnapshot = await Firestore.instance
          .collection(DictionaryWord.DICTIONARY_COLLECTION)
          .where(DictionaryWord.THOUGHTLIST, arrayContains: thoughtId)
          .getDocuments();
      if (querySnapshot == null || querySnapshot.documents.length == 0)
        print('querysnapshot is null');
      for (DocumentSnapshot doc in querySnapshot.documents) {
        keyword = DictionaryWord.deserialize(doc.data, doc.documentID).word;
        duplicate = false;
        if (myKeywords.isEmpty) {
          myKeywords
              .add(DictionaryWord.deserialize(doc.data, doc.documentID).word);
          duplicate = true;
        } else {
          myKeywords.forEach((n) => {if (n == keyword) duplicate == true});
        }
        ;
        if (!duplicate)
          myKeywords
              .add(DictionaryWord.deserialize(doc.data, doc.documentID).word);
      }
    } catch (e) {
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

  Future<bool> wordInDictionary(String searchWord) async {
    //Num listSearchTermCount
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection('dictionary')
          .where('word', isEqualTo: searchWord)
          .getDocuments();

      if (querySnapshot == null || querySnapshot.documents.length == 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(searchWord + " not found in dictionary e: " + e);
      throw e;
    }
  }

  Future<DictionaryWord> getWordDocument(String searchWord) async {
    //Num listSearchTermCount
    print("getWordDocument(" + searchWord + ")");
    DictionaryWord foundWordDocument;
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection('dictionary')
          .where('word', isEqualTo: searchWord)
          .getDocuments();

      if (querySnapshot == null || querySnapshot.documents.length == 0) {
        print("nothing found for " + searchWord);
        return foundWordDocument;
      } else {
        for (DocumentSnapshot doc in querySnapshot.documents) {
          foundWordDocument =
              DictionaryWord.deserialize(doc.data, doc.documentID);
        }

        print("found: " + foundWordDocument.word);

        return foundWordDocument;
      }
    } catch (e) {
      print(searchWord + " not found in dictionary with error e: " + e);
      throw e;
    }
  }

  //Future<List<Thought>> searchTermRetrieval(String searchTerm) async {
  Future<void> searchTermRetrieval(String searchTerm) async {
    print("searchTermRetrieval");
    //first break down search term into a list of terms
    var searchWordList = searchTerm
        .replaceAll(new RegExp(r"[^\'\w\s]+"), '')
        .replaceAll(new RegExp(r'[ ]{2,}'), ' ')
        .split(' ')
        .toSet();

    searchWordList.forEach((word) => {print(word)});

    Set<Thought> thoughtList = {};
    List<DictionaryWord> wordList = [];

    //get docs of all words we can find
    try {
      for (var searchWord in searchWordList) {
        QuerySnapshot queryDictionarySnapshot = await Firestore.instance
            .collection('dictionary')
            .where('word', isEqualTo: searchWord)
            .getDocuments();

        if (queryDictionarySnapshot == null ||
            queryDictionarySnapshot.documents.length == 0) {
        } else {
          for (DocumentSnapshot doc in queryDictionarySnapshot.documents) {
            wordList.add(DictionaryWord.deserialize(doc.data, doc.documentID));
          }
        }
      }
    } catch (e) {
      throw (e);
    }

    if (wordList.isNotEmpty) {
      try {
        for (var word in wordList) {
          for (var thoughtID in word.thoughtList) {
           var snapshot = await Firestore.instance.collection('thoughts')
                .document(thoughtID).get();
            thoughtList.add(Thought.deserialize(snapshot.data, snapshot.documentID));
          }
        }
      } catch (e) {
        throw (e);
      }

      thoughtList.forEach((thought) => {
        print(thought.text)
      });
    } else {
      print("wordList IS empty");
    }
  }
}
