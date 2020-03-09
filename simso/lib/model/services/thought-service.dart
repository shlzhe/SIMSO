import 'package:simso/model/entities/thought-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ithought-service.dart';

class ThoughtService extends IThoughtService {
  @override
  Future<String> addThought(Thought thought) async {
    DocumentReference ref = await Firestore.instance
        .collection(Thought.THOUGHTS_COLLECTION)
        .add(thought.serialize());
    return ref.documentID;
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
      print("Firebase thought-service.dart getThoughts() called");

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
}
