
class Message{

  Message({
    this.sender,
    this.receiver,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });

   final String sender;
   final String receiver;
   final String time;
   final String text;
   final bool isLiked;
   final bool unread;

// From object to map for Firebase  
  Map<String, dynamic> serialize() => 
  {
    ISLIKE: false,
    RECEIVER: receiver,
    SENDER: sender,
    TEXT: text,
    TIME: time,
    UNREAD: true,
  };
  // Fields
  static const ISLIKE = 'false';
  static const RECEIVER = 'receiver';
  static const SENDER = 'sender';
  static const TEXT = 'text';
  static const TIME = 'time';
  static const UNREAD = 'true';

}
  