
import 'package:simso/model/entities/user-model.dart';

abstract class IFriendService {
  Future<List<UserModel>> getUsers();
}