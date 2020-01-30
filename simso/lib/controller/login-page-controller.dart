
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/view/login-page.dart';

class LoginPageController{
  
  LoginPageState state;
  IUserService _userService;
  UserModel newUser = UserModel();
  String userID;

  LoginPageController(this.state, this._userService);

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
}