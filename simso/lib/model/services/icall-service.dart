import 'package:simso/model/entities/call-model.dart';
import 'package:simso/model/entities/user-model.dart';

abstract class ICallService {
  void addCall(Call thisCall);
  Future<bool> checkCall(UserModel thisUser);
  void deleteCall(Call thisCall);
}