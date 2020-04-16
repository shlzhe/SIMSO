import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/call-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/icall-service.dart';

class CallService extends ICallService {
  @override
  void addCall(Call thisCall) async {
    try {
      await Firestore.instance
          .collection(Call.CALLLOG)
          .add(thisCall.serialize());
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<bool> checkCall(UserModel thisUser) async {
    try {
      var document = await Firestore.instance
          .collection(Call.CALLLOG)
          .where(Call.RECEIVERUID, isEqualTo: thisUser.uid)
          .getDocuments();
      if (document.documents.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void deleteCall(Call thisCall) async{
    try {
      var query = await Firestore.instance.collection(Call.CALLLOG)
      .where(Call.CALLERUID, isEqualTo: thisCall.callerUid)
      .where(Call.RECEIVERUID, isEqualTo: thisCall.receiverUid).getDocuments();
      if(query.documents.isNotEmpty){
        query.documents.forEach((doc)=>{
          Firestore.instance.collection(Call.CALLLOG).document(doc.documentID).delete()
        });
      }
    } catch(e){
      print(e);
    }
  }
}
