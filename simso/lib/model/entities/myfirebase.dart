import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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

    //COLLECT MESSAGES THAT SENDER SENT TO RECEIVER
    QuerySnapshot querySnapshot1 = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: sender)
        .where('receiver', isEqualTo: receiver)
        .getDocuments();

    if (querySnapshot1 == null || querySnapshot1.documents.length == 0) {
      //print('Empty senderToReceiver');
    }
    for (DocumentSnapshot doc in querySnapshot1.documents) {
      //print('senderToReceiver is not empty');
      filteredMessages.add(Message.deserialize(doc.data, doc.documentID));
    }
    //COLLECTION MESSAGE THAT RECEIVER SENT TO SENDER
    QuerySnapshot querySnapshot2 = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: receiver)
        .where('receiver', isEqualTo: sender)
        .getDocuments();
   
    if (querySnapshot2 == null || querySnapshot2 .documents.length == 0) {
      //print('Empty receiverToSender');
    }
    for (DocumentSnapshot doc in querySnapshot2.documents) {
      print('receiverToSender is not empty');
      filteredMessages.add(Message.deserialize(doc.data, doc.documentID));
    }
   
    //SORTED FILTEREDMESSAGES BASED ON COUNTER
   
    filteredMessages.sort((a,b){
      DateTime aMessage = new DateFormat('MM-dd-yyyy - HH:mm:ss').parse(a.time);
      DateTime bMessage = new DateFormat('MM-dd-yyyy - HH:mm:ss').parse(b.time);
    
      return aMessage.compareTo(bMessage);
    });


      return filteredMessages;
    }

  static Future<List<Message>> getUnreadMessages(String currentUID) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('messages')
        .where('receiver', isEqualTo: currentUID)
        .where('unread',isEqualTo: true)
        .getDocuments();
    var messageCollection = <Message>[];
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      //print('No unread message');
      return messageCollection;
    }
    for (DocumentSnapshot doc in querySnapshot.documents) {
      //print('Have unread messages');
      messageCollection.add(Message.deserialize(doc.data, doc.documentID));
    }
    return messageCollection;
  }


  static Future<bool> checkUnreadMessage(String currentUID, String simUID) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('messages')
        .where('receiver', isEqualTo: currentUID)
        .where('sender', isEqualTo: simUID)
        .where('unread', isEqualTo: true)
        .getDocuments();
    var messageCollection = <Message>[];
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      //print('No unread message with $simUID');
      return false;
    }
    for (DocumentSnapshot doc in querySnapshot.documents) {
      //print('Have unread messages with $simUID');
      messageCollection.add(Message.deserialize(doc.data, doc.documentID));
    }
    return true;
  }




  static Future<void> updateUnreadMessage(String currentUID,String otherUID) async {
    //Get document ID of unread msg
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('messages')
        .where('sender', isEqualTo: otherUID)
        .where('receiver', isEqualTo: currentUID)
        .where('unread', isEqualTo: true)
        .getDocuments();
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      print('Read all messages');
    }
    for (DocumentSnapshot doc in querySnapshot.documents) {
      Firestore.instance.collection('messages').document(doc.documentID).updateData({'unread': false});
     
   }
    
  }
    
  }