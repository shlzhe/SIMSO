  class Message {
  Message({
    this.isLike,
    this.receiver,
    this.sender,
    this.text,
    this.time,
    this.unread,
    this.counter,
  });
  
  
  String documentID;
  bool isLike;
  String receiver;
  String sender;
  String text;
  String time;
  bool unread;
  int counter;

  static const ISLIKED = 'isLike';
  static const RECEIVER = 'receiver';
  static const SENDER = 'sender';
  static const TEXT = 'text';
  static const TIME = 'time';
  static const UNREAD = 'true';
  static const COUNTER ='counter';

  Message.deserialize(Map<String, dynamic> doc, String docID){
        documentID = docID;
        isLike = doc[ISLIKED];
        receiver = doc[RECEIVER];
        sender = doc[SENDER];
        text = doc[TEXT];
        time = doc[TIME];
        unread = doc[UNREAD];
        counter = doc[COUNTER]
;        
  }

  Map<String, dynamic> serialize() => 
  {
    ISLIKED: isLike,
    RECEIVER: receiver,
    SENDER: sender,
    TEXT: text,
    TIME: time,
    UNREAD: unread,
    COUNTER: counter,
  };
}