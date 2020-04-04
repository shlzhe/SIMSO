class Meme {
  String memeId; //firestore doc id
  String uid;
  String imgUrl;
  String email;
  String ownerName;
  String ownerPic;
  DateTime timestamp;
  List<dynamic> tags;

  Meme(
      {this.memeId,
      this.uid, 
      this.imgUrl,
      this.timestamp,
      this.tags,
      this.email,
      this.ownerName,
      this.ownerPic});

  Meme.empty() {
    this.uid = '';
    this.memeId = '';
    this.imgUrl = '';
    this.email = '';
    this.ownerPic = '';
    this.ownerName = '';
    this.tags = <dynamic>[];
  }

  Meme.clone(Meme c) {
    this.memeId = c.memeId;
    this.uid = c.uid;
    this.imgUrl = c.imgUrl;
    this.timestamp = c.timestamp;
    this.email = c.email;
    this.ownerName = c.ownerName;
    this.ownerPic = c.ownerPic;
    //.. iterates to create deep copy
    this.tags = <dynamic>[]..addAll(c.tags);
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      SNAPSHOTID: memeId,
      UID: uid,
      IMGURL: imgUrl,
      TIMESTAMP: timestamp,
      OWNERPIC: ownerPic,
      OWNERNAME: ownerName,
      TAGS: tags,
      EMAIL: email,
    };
  }

  static Meme deserialize(Map<String, dynamic> data, String docID) {
    var snapshot = Meme(
      memeId: data[Meme.SNAPSHOTID],
      uid: data[Meme.UID],
      imgUrl: data[Meme.IMGURL],
      tags: data[Meme.TAGS],
      email: data[Meme.EMAIL],
      ownerName: data[Meme.OWNERNAME],
      ownerPic: data[Meme.OWNERPIC]
    );
    if (data[Meme.TIMESTAMP] != null) {
      snapshot.timestamp = DateTime.fromMillisecondsSinceEpoch(
          data[Meme.TIMESTAMP].millisecondsSinceEpoch);
    }
    snapshot.memeId = docID;
    return snapshot;
  }

  static const MEMES_COLLECTION = 'snapshots';
  static const SNAPSHOTID = 'snapshotId';
  static const UID = 'uid';
  static const IMGURL = 'imgUrl';
  static const TIMESTAMP = 'timestamp';
  static const TAGS = 'tags';
  static const EMAIL = 'email';
  static const OWNERNAME = 'ownerName';
  static const OWNERPIC = 'ownerPic';
}
