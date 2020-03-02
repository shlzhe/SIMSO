import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/mainChat-page.dart';

class MainChatPageController {
  MainChatPageState state;
  ITimerService timerService;
  ITouchService touchService;
  UserModel user;
  List<UserModel>userList;

  String userID;
  //Constructor
  MainChatPageController (this.state, this.timerService, this.touchService,this.userList);


  Future<void> showUsers() async {
    print('showUsers() called');
        try{
            QuerySnapshot querySnapshot = await Firestore.instance.collection('users').getDocuments();
            if(querySnapshot == null || querySnapshot.documentChanges.length==0){
            print('Nothing in users collection');
           }
    
    for(DocumentSnapshot doc in querySnapshot.documents){
      print('${doc.documentID}');
      //userList.add(UserModel.deserialize(doc.data))
      userList.add(UserModel.deserialize(doc.data));
    }
    }catch(e){
      throw e.toString();
    }
    
}
}