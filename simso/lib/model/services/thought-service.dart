import 'package:simso/model/entities/thought-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/service-locator.dart';
import 'ithought-service.dart';
import 'idictionary-service.dart';
import 'package:translator/translator.dart';

class ThoughtService extends IThoughtService {
  IDictionaryService _dictionaryService = locator<IDictionaryService>();
  final translator = new GoogleTranslator();

  @override
  Future<void> addThought(Thought thought) async {
    await Firestore.instance
        .collection(Thought.THOUGHTS_COLLECTION)
        .add(thought.serialize())
        .then((docRef) {
      thought.thoughtId = docRef.documentID;
    }).catchError((onError) {
      print(onError);
      return null;
    });

    _dictionaryService.updateDictionary(thought, null, null);
  }

  @override
  Future<void> updateThought(Thought thought) async {
    await Firestore.instance
        .collection(Thought.THOUGHTS_COLLECTION)
        .document(thought.thoughtId)
        .setData(thought.serialize());
    //return ref.documentID;
    //get dictionary

    _dictionaryService.updateDictionary(thought, null, null);
  }

  @override
  Future<List<Thought>> getThoughts(String uid) async {
    var myThoughtsList = <Thought>[];
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(Thought.THOUGHTS_COLLECTION)
          .where(Thought.UID, isEqualTo: uid)
          .orderBy(Thought.TIMESTAMP)
          .getDocuments();
      if (querySnapshot == null || querySnapshot.documents.length == 0) {
        var newThought = Thought(
            tags: ['Welcome'],
            text: 'Welcome, add a new thought!',
            timestamp: DateTime.now(),
            uid: uid);
        myThoughtsList.add(newThought);
      } else
        for (DocumentSnapshot doc in querySnapshot.documents) {
          myThoughtsList.add(Thought.deserialize(doc.data, doc.documentID));
        }
    } catch (e) {
      throw e;
    }
    return myThoughtsList;
  }

  Future<void> deleteThought(String docID) async {
    try {
      await Firestore.instance
          .collection(Thought.THOUGHTS_COLLECTION)
          .document(docID)
          .delete();
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<Thought>> contentThoughtList(
      bool friends, UserModel user, String langPref) async {
    var data = <Thought>[];
    var friendsThoughtList = <Thought>[];
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(Thought.THOUGHTS_COLLECTION)
          .orderBy(Thought.TIMESTAMP)
          .getDocuments();
      for (DocumentSnapshot doc in querySnapshot.documents) {
        Thought newThought = Thought.deserialize(doc.data, doc.documentID);
        if (langPref != 'none' && langPref != null) {
          newThought.text =
              await translator.translate(newThought.text, to: langPref);
        }
        data.add(newThought);
      }
      data.removeWhere((element) => element.uid == user.uid.toString());
      if (!friends) {
        //new content remove friends content
        try {
          for (var i in user.friends) {
            data.removeWhere((element) => element.uid == i.toString());
          }
        } catch (error) {
          print(error);
        }
        return data;
      } else {
        try {
          for (var i in user.friends) {
            //friends content remove public content
            var temp = data.where((element) => element.uid == i.toString());
            friendsThoughtList.addAll(temp);
          }
        } catch (error) {
          print(error);
        }
      }
      return friendsThoughtList;
    } catch (error) {
      return data;
    }
  }
}
