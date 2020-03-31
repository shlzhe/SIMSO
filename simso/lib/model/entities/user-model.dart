class UserModel {
  UserModel({
    this.uid,
    this.username,
    this.email,
    this.aboutme,
    this.city,
    this.relationship,
    this.memo,
    this.profilePic,
    this.favorites,
    this.password,
    this.friendRequestSent,
    this.friendRequestRecieved,
    this.friends,
    this.gender,
    this.age,
  });
  UserModel.isEmpty() {
    this.uid = '';
    this.username = '';
    this.email = '';
    this.aboutme = '';
    this.city = '';
    this.relationship = '';
    this.memo = '';
    this.profilePic = '';
    this.favorites = '';
    this.friendRequestSent = [];
    this.friendRequestRecieved = [];
    this.friends = [];
    this.gender = 'S';
    this.age = 0;
    this.answers = [];
  }
  UserModel.clone(UserModel b) {
    this.uid = b.uid;
    this.username = b.username;
    this.email = b.email;
    this.aboutme = b.aboutme;
    this.city = b.city;
    this.relationship = b.relationship;
    this.memo = b.memo;
    this.profilePic = b.profilePic;
    this.favorites = b.favorites;
    this.friends = b.friends;
    this.gender = b.gender;
    this.age = b.age;
    this.answers = b.answers;
  }
  String uid;
  String username;
  String email;
  String aboutme;
  String city;
  String relationship;
  String memo;
  String profilePic;
  String favorites;
  String password;
  List<dynamic> friendRequestSent;
  List<dynamic> friendRequestRecieved;
  List<dynamic> friends;
  List<dynamic> answers;
  String gender;
  int age;

  static const UID = 'UID';
  static const USERNAME = 'username';
  static const EMAIL = 'email';
  static const ABOUTME = 'aboutme';
  static const CITY = 'city';
  static const RELATIONSHIP = 'relationship';
  static const MEMO = 'memo';
  static const PROFILEPIC = 'profilepic';
  static const FAVORITES = 'favorites';
  static const USERCOLLECTION = 'users';
  static const FRIENDREQUESTSENT = 'friendRequestSent';
  static const FRIENDREQUESTRECIEVED = 'friendRequestRecieved';
  static const FRIENDS = 'friends';
  static const GENDER = 'gender';
  static const AGE = 'age';
  static const ANSWERS = 'Answers';

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      UID: uid,
      USERNAME: username,
      EMAIL: email,
      ABOUTME: aboutme,
      CITY: city,
      RELATIONSHIP: relationship,
      MEMO: memo,
      PROFILEPIC: profilePic,
      FAVORITES: favorites,
      FRIENDREQUESTSENT: friendRequestSent,
      FRIENDREQUESTRECIEVED: friendRequestRecieved,
      FRIENDS: friends,
      GENDER: gender,
      AGE: age,
      ANSWERS: answers,
    };
  }

  UserModel.deserialize(Map<String, dynamic> doc)
      : uid = doc[UID],
        username = doc[USERNAME],
        email = doc[EMAIL],
        aboutme = doc[ABOUTME],
        city = doc[CITY],
        relationship = doc[RELATIONSHIP],
        memo = doc[MEMO],
        profilePic = doc[PROFILEPIC],
        favorites = doc[FAVORITES],
        friendRequestSent = doc[FRIENDREQUESTSENT],
        friendRequestRecieved = doc[FRIENDREQUESTRECIEVED],
        friends = doc[FRIENDS],
        gender = doc[GENDER],
        age = doc[AGE],
        answers = doc[ANSWERS];
}
