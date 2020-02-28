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
          //.orderBy(Course.STARTDATE) //preindexing since using multiple indexes
          .orderBy(Thought.TIMESTAMP)
          .getDocuments();
      var thoughts = <Thought>[];
      print("Firebase getThoughts called");

      if (querySnapshot == null || querySnapshot.documents.length == 0) {
        return thoughts;
      }
      for (DocumentSnapshot doc in querySnapshot.documents) {
        thoughts.add(Thought.deserialize(doc.data, doc.documentID));
      }
      return thoughts;
    } catch (e) {
      throw e;
    }
  }

}
