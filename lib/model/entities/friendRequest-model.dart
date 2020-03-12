class FriendRequests {
  String uid;
  String username;
  String aboutme;
  String profilePic;


FriendRequests({this.uid, this.username, this.aboutme, this.profilePic});

  static FriendRequests deserialize(Map<String, dynamic> document){
    return FriendRequests(
      uid: document[UID],
      username: document[USERNAME],
      aboutme: document[ABOUTME],
      profilePic: document[PROFILEPIC]
    );
  }

  static const UID = 'uid';
  static const USERNAME = 'username';
  static const ABOUTME = 'aboutme';
  static const PROFILEPIC = 'profilepic';

}