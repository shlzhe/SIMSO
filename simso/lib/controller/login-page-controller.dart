
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/view/login-page.dart';

class LoginPageController{
  
  LoginPageState state;
  IUserService _userService;

  LoginPageController(this.state, this._userService);

  void getUserData() async {
    state.user = await _userService.getUserDataByID('GKMeowyUPWf5eOj2ro0h');
      state.stateChanged(() => {});
  }

  void saveUser() async {
    var user = UserModel(username: 'test from post', email: 'test@test.email');
    await _userService.saveUser(user);
  }
}