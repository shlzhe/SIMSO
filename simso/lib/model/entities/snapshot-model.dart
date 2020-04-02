class Snapshot {
  String snapshotId; //firestore doc id
  String uid;
  String imgUrl;
  String email;
  String ownerName;
  String ownerPic;
  DateTime timestamp;
  List<dynamic> tags;

  Snapshot(
      {this.snapshotId,
      this.uid, 
      this.imgUrl,
      this.timestamp,
      this.tags,
      this.email,
      this.ownerName,
      this.ownerPic});

  Snapshot.empty() {
    this.uid = '';
    this.snapshotId = '';
    this.imgUrl = '';
    this.email = '';
    this.ownerPic = '';
    this.ownerName = '';
    this.tags = <dynamic>[];
  }

  Snapshot.clone(Snapshot c) {
    this.snapshotId = c.snapshotId;
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
      SNAPSHOTID: snapshotId,
      UID: uid,
      IMGURL: imgUrl,
      TIMESTAMP: timestamp,
      OWNERPIC: ownerPic,
      OWNERNAME: ownerName,
      TAGS: tags,
      EMAIL: email,
    };
  }

  static Snapshot deserialize(Map<String, dynamic> data, String docID) {
    var snapshot = Snapshot(
      snapshotId: data[Snapshot.SNAPSHOTID],
      uid: data[Snapshot.UID],
      imgUrl: data[Snapshot.IMGURL],
      tags: data[Snapshot.TAGS],
      email: data[Snapshot.EMAIL],
      ownerName: data[Snapshot.OWNERNAME],
      ownerPic: data[Snapshot.OWNERPIC]
    );
    if (data[Snapshot.TIMESTAMP] != null) {
      snapshot.timestamp = DateTime.fromMillisecondsSinceEpoch(
          data[Snapshot.TIMESTAMP].millisecondsSinceEpoch);
    }
    snapshot.snapshotId = docID;
    return snapshot;
  }

  static const SNAPSHOTS_COLLECTION = 'snapshots';
  static const SNAPSHOTID = 'snapshotId';
  static const UID = 'uid';
  static const IMGURL = 'imgUrl';
  static const TIMESTAMP = 'timestamp';
  static const TAGS = 'tags';
  static const EMAIL = 'email';
  static const OWNERNAME = 'ownerName';
  static const OWNERPIC = 'ownerPic';
}
