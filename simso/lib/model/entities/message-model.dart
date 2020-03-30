
class Message{
   final String sender;
   final String receiver;
   final String time;
   final String text;
   final bool isLiked;
   final bool unread;

  Message({
    this.sender,
    this.receiver,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}
  