import 'package:simso/model/entities/call-model.dart';
import 'package:simso/model/entities/user-model.dart';

abstract class ICallService {
  void addCall(Call thisCall);
  Future<Call> checkCall(String thisUser);
  void deleteCall(Call thisCall);
}