class Friend {
  String uid;
  String username;
  String aboutme;
  String profilePic;


Friend({this.uid, this.username, this.aboutme, this.profilePic});

  static Friend deserialize(Map<String, dynamic> document){
    return Friend(
      username: document[USERNAME],
      aboutme: document[ABOUTME],
      uid: document[UID],
      profilePic: document[PROFILEPIC]
    );
  }

  static const USERNAME = 'username';
  static const ABOUTME = 'aboutme';
  static const UID = 'uid';
  static const PROFILEPIC = 'profilepic';

}