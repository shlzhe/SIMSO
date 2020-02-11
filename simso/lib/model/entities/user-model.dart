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

    //Add for google sign in 
    this.gmail,
    this.gPassword,

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

  //Add for google sign in 
  String gmail;
  String gPassword;

  static const UID = 'UID';
  static const USERNAME = 'username';
  static const EMAIL = 'email';
  static const ABOUTME = 'aboutme';
  static const CITY = 'city';
  static const RELATIONSHIP = 'relationship';
  static const MEMO = 'memo';
  static const PROFILEPIC = 'profilepic';
  static const FAVORITES = 'favorites';
  static const UserCollection = 'users';

  //Add for google sign in 
  static const GMAIL = 'gmail';
  static const GPASSWORD = 'gPassword';

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
    };
  }

  static UserModel deserialize(Map<String, dynamic> doc){
    return UserModel(
      uid: doc[UID],
      username: doc[USERNAME],
      email: doc[EMAIL],
      aboutme: doc[ABOUTME],
      city: doc[CITY],
      relationship: doc[RELATIONSHIP],
      memo: doc[MEMO],
      profilePic: doc[PROFILEPIC],
      favorites: doc[FAVORITES],
    );
  }

  UserModel.fromJson(Map<String, dynamic> json): 
    username = json['username'],
    email = json['email'];

  Map<String, dynamic> toJson() {
    return {
      'username' : username,
      'email' : email
    };
  }
}