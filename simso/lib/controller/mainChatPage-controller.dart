import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/mainChat-page.dart';

class MainChatPageController {
  MainChatPageState state;
  ITimerService timerService;
  ITouchService touchService;
  UserModel newUser = UserModel();
  String userID;
  //Constructor
  MainChatPageController (this.state, this.timerService, this.touchService);

}