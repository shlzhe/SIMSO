class Thought {
  String thoughtId; //firestore doc id
  String uid;
  String text;
  String email;
  String profilePic;
  DateTime timestamp;
  List<dynamic> tags;

  Thought({
    this.uid, //uuid
    this.text,
    this.timestamp,
    this.tags,
    this.email,
    this.profilePic,
  });

  Thought.empty() {
    this.uid = '';
    this.text = '';
    this.email = '';
    this.profilePic = '';
    this.tags = <dynamic>[];
  }

  Thought.clone(Thought c) {
    this.thoughtId = c.thoughtId;
    this.uid = c.uid;
    this.text = c.text;
    this.timestamp = c.timestamp;
    this.email = c.email;
    this.profilePic = c.profilePic;
    //.. iterates to create deep copy
    this.tags = <dynamic>[]..addAll(c.tags);
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      UID: uid,
      TEXT: text,
      TIMESTAMP: timestamp,
      TAGS: tags,
      EMAIL: email,
      PROFILEPIC: profilePic,
    };
  }

  static Thought deserialize(Map<String, dynamic> data, String docID) {
    var thought = Thought(
      uid: data[Thought.UID],
      text: data[Thought.TEXT],
      tags: data[Thought.TAGS],
      email: data[Thought.EMAIL],
      profilePic: data[Thought.PROFILEPIC],
    );
    if(data[Thought.TIMESTAMP] != null){
      thought.timestamp = DateTime.fromMillisecondsSinceEpoch(
        data[Thought.TIMESTAMP].millisecondsSinceEpoch);
    }
    thought.thoughtId = docID;
    return thought;
  }

  static const THOUGHTS_COLLECTION = 'thoughts';
  static const UID = 'uid';
  static const TEXT = 'text';
  static const TIMESTAMP = 'timestamp';
  static const TAGS = 'tags';
  static const EMAIL = 'email';
  static const PROFILEPIC = 'profilePic';
}
