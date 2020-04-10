import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/user-model.dart';

abstract class IMessageService {
  Future<List<Message>> getMessages(String sender);
  Future<List<Message>> getFilteredMessages(String sender, String receiver);
  Future<void> addMessage(Message message);
  Future<void> updateFavorite(Message message);
}