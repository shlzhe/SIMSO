import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/user-model.dart';

abstract class IThoughtService {
  Future<List<Thought>> getThoughts(String uid);
  Future<void> addThought(Thought thought);
  Future<void> updateThought(Thought thought);
  Future<void> deleteThought(String uid);
  Future<List<Thought>> contentThoughtList(bool friends, UserModel user);
  Future<String> translateThought(String langPref, String text);
}
