import '../entities/user-model.dart';

abstract class IUserService {
  Future<UserModel> getUserDataByID(String id);
  Future<String> saveUser(UserModel user);
}