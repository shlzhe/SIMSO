import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/semantics.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/imessage-service.dart';

class MessageService implements IMessageService {
  @override
  Future<List<Message>> getFilteredMessages(String sender, String receiver) async {
    var filteredMessages = <Message>[];
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: sender)
        .where('receiver', isEqualTo: receiver)
        .getDocuments();

    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      print('Empty filteredMessages');
      return filteredMessages;
    }
    for (DocumentSnapshot doc in querySnapshot.documents) {
      print('FilteredMessages is not empty');
      filteredMessages.add(Message.deserialize(doc.data, doc.documentID));
    }
    //SORTED FILTEREDMESSAGES BASED ON COUNTER
    filteredMessages.sort((a, b) => a.counter.compareTo(b.counter));

    return filteredMessages;
  }

  @override
  Future<List<Message>> getMessages(String sender) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: sender)
        .getDocuments();
    var messageCollection = <Message>[];
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      print('Empty messageCollection');
      return messageCollection;
    }
    for (DocumentSnapshot doc in querySnapshot.documents) {
      print('messages Collection is not empty');
      messageCollection.add(Message.deserialize(doc.data, doc.documentID));
    }
    return messageCollection;
  }

  @override
  Future<void> addMessage(Message message) async {
    print('addMessage called');
    await Firestore.instance.collection('messages')
      .add(message.serialize())
      .then((docRef) {
        message.documentID = docRef.documentID;
      })
      .catchError((onError) {
        print(onError);
        return null;
      });
  }
  
  
  
}
