

  class Message {
  Message({
    this.isLiked,
    this.receiver,
    this.sender,
    
    this.text,
    this.time,
    this.unread,
    this.counter,
  });
  
  
  
  bool isLiked;
    String receiver;
    String sender;
    String text;
    String time;
    bool unread;
    int counter;

  static const ISLIKED = 'false';
  static const RECEIVER = 'receiver';
  static const SENDER = 'sender';
  static const TEXT = 'text';
  static const TIME = 'time';
  static const UNREAD = 'true';
  static const COUNTER ='counter';

  Message.deserialize(Map<String, dynamic> doc){
        isLiked = doc[ISLIKED];
        receiver = doc[RECEIVER];
        sender = doc[SENDER];
        text = doc[TEXT];
        time = doc[TIME];
        unread = doc[UNREAD];
        counter = doc[COUNTER]
;        
  }


  
}