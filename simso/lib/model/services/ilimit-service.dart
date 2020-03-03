import 'package:simso/model/entities/limit-model.dart';

abstract class ILimitService {
  Future<LimitModel> getLimit(String userID);
  Future<LimitModel> createLimit(String userID);
  Future<bool> updateLimit(LimitModel limit);
}