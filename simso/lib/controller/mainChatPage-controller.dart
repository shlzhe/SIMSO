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
  bool publicFlag;
  String userID;
  //Constructor
  MainChatPageController (this.state);


  Future<void> showUsers() async {
    print('showUsers() called');
    publicFlag = true;
    try{
      print('${state.userList.length.toString()}');
      state.stateChanged((){
        state.publicFlag = true;
      });
    }catch(e){
      throw e.toString();
    }
  }
}