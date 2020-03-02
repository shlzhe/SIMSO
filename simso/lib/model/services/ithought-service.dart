import 'package:simso/model/entities/thought-model.dart';

abstract class IThoughtService {
  Future<String> addThought(Thought thought);
  Future<List<Thought>> getThoughts(String uid);
}
