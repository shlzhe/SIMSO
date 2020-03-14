import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/dictionary-word-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/service-locator.dart';
import 'ithought-service.dart';
import 'idictionary-service.dart';

class ThoughtService extends IThoughtService {
  IDictionaryService _dictionaryService = locator<IDictionaryService>();

  @override
  Future<void> addThought(Thought thought) async {

    await Firestore.instance.collection(Thought.THOUGHTS_COLLECTION)
      .add(thought.serialize())
      .then((docRef) {
        thought.thoughtId = docRef.documentID;
      })
      .catchError((onError) {
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
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(Thought.THOUGHTS_COLLECTION)
          .where(Thought.UID, isEqualTo: uid)
          .orderBy(Thought.TIMESTAMP)
          .getDocuments();
      var myThoughtsList = <Thought>[];
      

      if (querySnapshot == null || querySnapshot.documents.length == 0) {
        var newThought = Thought(
            tags: ['Welcome'],
            text: 'Welcome, add a new thought!',
            timestamp: DateTime.now(),
            uid: uid);
        myThoughtsList.add(newThought);

        return myThoughtsList;
      }
      for (DocumentSnapshot doc in querySnapshot.documents) {
        myThoughtsList.add(Thought.deserialize(doc.data, doc.documentID));
      }
      return myThoughtsList;
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteThought(String docID) async {
    try{
    await Firestore.instance
        .collection(Thought.THOUGHTS_COLLECTION)
        .document(docID)
        .delete();
    } catch (e){
      throw e;
    }

  }
}
