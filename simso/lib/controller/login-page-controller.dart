
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/view/login-page.dart';
import '../model/entities/globals.dart' as globals;

class LoginPageController{
  
  LoginPageState state;
  IUserService _userService;
  ITimerService _timerService;
  UserModel newUser = UserModel();
  String userID;

  LoginPageController(this.state, this._userService, this._timerService);

  void getUserData() async {
    state.formKey.currentState.save();
    state.user = await _userService.getUserDataByID(userID);
    state.stateChanged(() => {});
  }

  void saveUser() async {
    state.formKey.currentState.save();
    state.returnedID = await _userService.saveUser(newUser);
    state.idController.text = state.returnedID;
    state.stateChanged(() => {});
    print(state.returnedID);
  }

  void saveEmail(String value) {
    newUser.email = value;
  }

  void saveUsername(String value) {
    newUser.username = value;
  }

  void saveUserID(String value) {
    userID = value;
  }

  void getTimer() async {
    globals.timer = await _timerService.getTimer('k9tJ9uP4ZvNokxEfxSlm', 0);
  }

  void saveTimer() async {
    await _timerService.updateTimer(globals.timer);
  }

  void refreshState() {
    state.stateChanged(() => {});
  }
}