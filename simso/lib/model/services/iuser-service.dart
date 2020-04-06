import '../entities/user-model.dart';

// A service for contactin the API regarding User data.
// The methods here provide an interface
abstract class IUserService {
  Future<String> createAccount(UserModel user);
  void createUserDB(UserModel user);
  Future<void> updateUserDB(UserModel user);
  Future<String> login(UserModel user);
  Future<UserModel> readUser(String uid);
  Future<List<UserModel>> readAllUser();
  void changePassword(UserModel user, String password);
  void deleteUser(UserModel user);
  Future<List<dynamic>> readQuestion();
  Future<List<dynamic>> answerQuestion(String email);
  Future<String> friendthoughts(String uid);
  Future<List<UserModel>> readUsername();
}
