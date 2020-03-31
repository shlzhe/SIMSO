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
      messageCollection.add(Message.deserialize(doc.data));
    }
    return messageCollection;
    }

    static Future<List<Message>> getFilteredMessages(String sender, String receiver) async {
       var filteredMessages = <Message>[];      
       QuerySnapshot querySnapshot = await Firestore.instance.collection('messages')
        .where('sender',isEqualTo: sender)
        .where('receiver', isEqualTo: receiver)
        .getDocuments();
       
         if (querySnapshot == null || querySnapshot.documents.length ==0){
            print('Empty filteredMessages');
            return filteredMessages;
    }
        for (DocumentSnapshot doc in querySnapshot.documents){
     
          print('FilteredMessages is not empty');
          filteredMessages.add(Message.deserialize(doc.data));
    }
          return filteredMessages;
    }
    
  }
