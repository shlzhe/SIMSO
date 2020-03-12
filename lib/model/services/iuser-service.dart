import '../entities/user-model.dart';

// A service for contactin the API regarding User data.
// The methods here provide an interface
abstract class IUserService {
  Future<String> createAccount(UserModel user);
  void createUserDB(UserModel user);
  Future<String> login(UserModel user);
  Future<UserModel> readUser(String uid);
}