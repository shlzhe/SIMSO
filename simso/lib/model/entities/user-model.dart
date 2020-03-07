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
    this.friends
    });
  UserModel.isEmpty(){
    this.uid = '';
    this.username = ''; 
    this.email = '';
    this.aboutme = '';
    this.city = '';
    this.relationship = '';
    this.memo = '';
    this.profilePic = '';
    this.favorites = '';
    this.friends = [];
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
  List<dynamic> friends;

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
  static const FRIENDS = 'friends';

  Map<String, dynamic> serialize(){
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
      FRIENDS: friends
    };
  }

  UserModel.deserialize(Map<String, dynamic> doc):
      uid = doc[UID],
      username = doc[USERNAME],
      email = doc[EMAIL],
      aboutme = doc[ABOUTME],
      city = doc[CITY],
      relationship = doc[RELATIONSHIP],
      memo = doc[MEMO],
      profilePic = doc[PROFILEPIC],
      favorites = doc[FAVORITES],
      friends =  doc[FRIENDS];

}