import 'package:simso/model/entities/snapshot-model.dart';
import 'package:simso/model/entities/dictionary-word-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/service-locator.dart';
import 'isnapshot-service.dart';
//import 'idictionary-service.dart';

class SnapshotService extends ISnapshotService {
  //IDictionaryService _dictionaryService = locator<IDictionaryService>();

  @override
  Future<void> addSnapshot(Snapshot snapshot) async {

    await Firestore.instance.collection(Snapshot.SNAPSHOTS_COLLECTION)
      .add(snapshot.serialize())
      .then((docRef) {
        snapshot.snapshotId = docRef.documentID;
      })
      .catchError((onError) {
        print(onError);
        return null;
      });
    
   // _dictionaryService.updateDictionary(null, null, null);
  }

  @override
  Future<void> updateSnapshot(Snapshot snapshot) async {
    await Firestore.instance
        .collection(Snapshot.SNAPSHOTS_COLLECTION)
        .document(snapshot.snapshotId)
        .setData(snapshot.serialize());
    //return ref.documentID;
    //get dictionary

   // _dictionaryService.updateDictionary(null, null, null);
  }

  @override
  Future<List<Snapshot>> getSnapshots(String uid) async {
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(Snapshot.SNAPSHOTS_COLLECTION)
          .where(Snapshot.UID, isEqualTo: uid)
          .orderBy(Snapshot.TIMESTAMP)
          .getDocuments();
      var mySnapshotsList = <Snapshot>[];
      

      if (querySnapshot == null || querySnapshot.documents.length == 0) {
        // var newSnapshot = Snapshot(
        //     tags: ['Welcome'],
        //     ownerPic: '',
        //     imgUrl: 'https://blog.vantagecircle.com/content/images/2019/09/welcome.png',
        //     timestamp: DateTime.now(),
        //     uid: uid);
        // mySnapshotsList.add(newSnapshot);
        return mySnapshotsList;
      }
      for (DocumentSnapshot doc in querySnapshot.documents) {
        mySnapshotsList.add(Snapshot.deserialize(doc.data, doc.documentID));
      }
      return mySnapshotsList;
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteSnapshot(String docID) async {
    try{
    await Firestore.instance
        .collection(Snapshot.SNAPSHOTS_COLLECTION)
        .document(docID)
        .delete();
    } catch (e){
      throw e;
    }

  }

  @override
  Future<List<Snapshot>> contentSnapshotList(bool friends, List<dynamic> friendslist) async {
    var data = <Snapshot>[];
    var friendsSnapshotList = <Snapshot>[];
    try {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection(Snapshot.SNAPSHOTS_COLLECTION)
          .orderBy(Snapshot.TIMESTAMP)
          .getDocuments();
      for (DocumentSnapshot doc in querySnapshot.documents) {
        data.add(Snapshot.deserialize(doc.data, doc.documentID));
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
            friendsSnapshotList.addAll(temp);
          }
        }catch(error){print(error);}
      }
      return friendsSnapshotList;
    }catch(error){
      return data;
    }
  }
}
