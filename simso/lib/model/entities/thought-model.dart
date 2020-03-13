class Thought {
  String thoughtId; //firestore doc id
  String uid;
  String text;
  DateTime timestamp;
  List<dynamic> tags;

  Thought({
    this.uid, //uuid
    this.text,
    this.timestamp,
    this.tags,
  });

  Thought.empty() {
    this.uid = '';
    this.text = '';
    this.tags = <dynamic>[];
  }

  Thought.clone(Thought c) {
    this.thoughtId = c.thoughtId;
    this.uid = c.uid;
    this.text = c.text;
    this.timestamp = c.timestamp;
    //.. iterates to create deep copy
    this.tags = <dynamic>[]..addAll(c.tags);
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      UID: uid,
      TEXT: text,
      TIMESTAMP: timestamp,
      TAGS: tags,
    };
  }

  static Thought deserialize(Map<String, dynamic> data, String docID) {
    var thought = Thought(
      uid: data[Thought.UID],
      text: data[Thought.TEXT],
      tags: data[Thought.TAGS],
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
}
