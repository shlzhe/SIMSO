import '../entities/user-model.dart';

// A service for contactin the API regarding User data.
// The methods here provide an interface
abstract class IUserService {
  Future<UserModel> getUserDataByID(String id);
  Future<String> saveUser(UserModel user);
}