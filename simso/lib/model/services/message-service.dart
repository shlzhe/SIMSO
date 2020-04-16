import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:simso/model/entities/message-model.dart';

import 'package:simso/model/services/imessage-service.dart';

class MessageService implements IMessageService {
  @override
  Future<List<Message>> getFilteredMessages(String sender, String receiver) async {
    var filteredMessages = <Message>[];  //all messages 

    //COLLECT MESSAGES THAT SENDER SENT TO RECEIVER
    QuerySnapshot querySnapshot1 = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: sender)
        .where('receiver', isEqualTo: receiver)
        .getDocuments();

    if (querySnapshot1 == null || querySnapshot1.documents.length == 0) {
      print('Empty senderToReceiver');
    }
    for (DocumentSnapshot doc in querySnapshot1.documents) {
      print('senderToReceiver is not empty');
      filteredMessages.add(Message.deserialize(doc.data, doc.documentID));
    }
    //COLLECTION MESSAGE THAT RECEIVER SENT TO SENDER
    QuerySnapshot querySnapshot2 = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: receiver)
        .where('receiver', isEqualTo: sender)
        .getDocuments();
   
    if (querySnapshot2 == null || querySnapshot2 .documents.length == 0) {
      print('Empty receiverToSender');
    }
    for (DocumentSnapshot doc in querySnapshot2.documents) {
      print('receiverToSender is not empty');
      filteredMessages.add(Message.deserialize(doc.data, doc.documentID));
    }
    Message tempMessage;
    var currentDateTime;
    var nextDateTime;
    List<String> dateTimes;
    //SORTED FILTEREDMESSAGES BASED ON COUNTER
   
    filteredMessages.sort((a,b){
      DateTime aMessage = new DateFormat('MM-dd-yyyy - HH:mm:ss').parse(a.time);
      DateTime bMessage = new DateFormat('MM-dd-yyyy - HH:mm:ss').parse(b.time);
    
      return aMessage.compareTo(bMessage);
    });


    for(int i=0; i<filteredMessages.length -1 ; i++) {
      //print('BEFORE: ' + '${filteredMessages[i].time}');
      tempMessage=null;
      currentDateTime = new DateFormat('MM-dd-yyyy - HH:mm:ss').parse(filteredMessages[i].time);
      nextDateTime  = new DateFormat('MM-dd-yyyy - HH:mm:ss').parse(filteredMessages[i+1].time);
    }
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


  @override
  Future<void> updateFavorite(Message message) async {
    //Get document ID of favored message 
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: message.sender)
        .where('receiver', isEqualTo: message.receiver)
        .where('time', isEqualTo: message.time)
        .getDocuments();
    for (DocumentSnapshot doc in querySnapshot.documents) {
      if(message.isLike == true)
      Firestore.instance.collection('messages').document(doc.documentID).updateData({'isLike': false});
      else
      Firestore.instance.collection('messages').document(doc.documentID).updateData({'isLike': true});
      
   }
    
  }
  
 
  
}
