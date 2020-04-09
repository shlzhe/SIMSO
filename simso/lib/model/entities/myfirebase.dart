import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/user-model.dart';

class MyFirebase{
  static Future<List<UserModel>> getUsers() async{

    QuerySnapshot querySnapshot = await Firestore.instance.collection('users')
      .getDocuments();
    var userList = <UserModel>[];
    if (querySnapshot == null || querySnapshot.documents.length ==0){
      print('Empty userList');
      return userList;
    }
    for (DocumentSnapshot doc in querySnapshot.documents){
      print('Users Collection is not empty');
      userList.add(UserModel.deserialize(doc.data));
    }

    return userList;

    }

    static Future<List<Message>> getMessages(String sender) async{
      QuerySnapshot querySnapshot = await Firestore.instance.collection('messages')
        .where('sender',isEqualTo: sender).getDocuments();
        var messageCollection = <Message>[];
      if (querySnapshot == null || querySnapshot.documents.length ==0){
      print('Empty messageCollection');
      return messageCollection;
    }
      for (DocumentSnapshot doc in querySnapshot.documents){
     
      print('messages Collection is not empty');
      messageCollection.add(Message.deserialize(doc.data, doc.documentID));
    }
    return messageCollection;
    }

    static Future<List<Message>> getFilteredMessages(String sender, String receiver) async {
    var filteredMessages = <Message>[];  //all messages 
    var senderToReceiver = <Message>[];  
    var receiverToSender = <Message>[];


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

    //SORTED FILTEREDMESSAGES BASED ON COUNTER
    filteredMessages.sort((a, b) => a.counter.compareTo(b.counter));

     //SORTED FILTERED BASED ON TIMESTAMP
          /*
          var newDateTime = new DateFormat('MM-dd-yyyy - HH:mm:ss').parse(formattedDate);
          DateTime sampleDT = new DateFormat('MM-dd-yyyy - HH:mm:ss').parse('04-30-2019 - 19:24:22');
          if(sampleDT.isBefore(newDateTime)){print('sampleDT is before newDateTime');}
          else {print('sampleDT is after newDateTime');}
          */
          return filteredMessages;
    }

    
  }