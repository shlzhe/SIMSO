import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/dictionary-word-model.dart';

abstract class IThoughtService {
  Future<List<Thought>> getThoughts(String uid);
  Future<void> addThought(Thought thought);
  Future<void> updateThought(Thought thought);
  Future<void> deleteThought(String uid);
}
