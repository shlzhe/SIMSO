import 'package:firebase_auth/firebase_auth.dart';

class User{
  String profilePic;
  String email;
  String password;
  String displayName;
  int zip;
  int numOfPets;
  String street;
  String city;
  String state;
  String level;
  double boardingRate;
  double walkingRate;
  double dayCare;
  double dropInVisit;
  double houseSitting;
  String lati;
  String longti;
  String searchAdd;

  // need to create a list or map of pets

  String uid; //uid in Firestore 

  //Creative 
  FirebaseAuth auth;
  FirebaseUser user;

  //User constructor
  User({
    this.email,
    this.password,
    this.displayName,
    this.zip,
    this.uid,
    this.profilePic='',
    this.numOfPets=0,
    this.street,
    this.city,
    this.state,
    this.level='user',
    this.boardingRate=0,
    this.walkingRate=0,
    this.dayCare=0,
    this.dropInVisit=0,
    this.houseSitting=0,
    this.lati,
    this.longti,
    this.searchAdd,
  });
  

  Map<String, dynamic> serialize(){
      return <String,dynamic>{
        EMAIL: email,
        DISPLAYNAME: displayName,
        ZIP: zip,
        UID: uid,
        PROFILE_PIC: profilePic,
        STREET: street,
        NUMOFPETS: numOfPets,
        CITY: city,
        STATE: state,
        LEVEL: level,
        BOARDINGRATE: boardingRate,
        WALKINGRATE: walkingRate,
        DAYCARERATE: dayCare,
        DROPINRATE: dropInVisit,
        HOUSESITTINGRATE: houseSitting,
        LATI: lati,
        LONGTI: longti,
        SEARCHADD: searchAdd
      };
  }
  Map<String, dynamic> serializeProviderList() {
    return <String,dynamic>{
        EMAIL: email,
        DISPLAYNAME: displayName,
        STREET: street,
        ZIP: zip,
        PROFILE_PIC: profilePic,
        CITY: city,
        STATE: state,
        BOARDINGRATE: boardingRate,
        WALKINGRATE: walkingRate,
        DAYCARERATE: dayCare,
        DROPINRATE: dropInVisit,
        HOUSESITTINGRATE: houseSitting,
        LATI: lati,
        LONGTI: longti,
        SEARCHADD: searchAdd
      };
  }
  static User deserialize(Map<String,dynamic> document){
    return User(
      email: document [EMAIL],
      displayName: document [DISPLAYNAME],
      zip: document [ZIP],
      uid: document [UID],
      profilePic: document [PROFILE_PIC],
      street: document [STREET],
      numOfPets: document [NUMOFPETS],
      city: document[CITY],
      state: document[STATE],
      level: document[LEVEL],
      boardingRate: document[BOARDINGRATE],
      walkingRate: document[WALKINGRATE],
      dayCare: document[DAYCARERATE],
      dropInVisit: document[DROPINRATE],
      houseSitting: document[HOUSESITTINGRATE],
      lati: document[LATI],
      longti: document[LONGTI],
      searchAdd: document[SEARCHADD],
    );
  }
  static User deserializeProviderList(Map<String,dynamic> document){
    return User(
      email: document [EMAIL],
      displayName: document [DISPLAYNAME],
      zip: document [ZIP],
      profilePic: document [PROFILE_PIC],
      street: document [STREET],
      city: document[CITY],
      state: document[STATE],
      boardingRate: document[BOARDINGRATE],
      walkingRate: document[WALKINGRATE],
      dayCare: document[DAYCARERATE],
      dropInVisit: document[DROPINRATE],
      houseSitting: document[HOUSESITTINGRATE],
      lati: document[LATI],
      longti: document[LONGTI],
      searchAdd: document[SEARCHADD],
    );
  }

  //password is saved in authentication
  static const PROFILE_COLLECTION = 'userprofile';
  static const EMAIL = 'email';
  static const DISPLAYNAME = 'displayName';
  static const ZIP = 'zip';
  static const UID = 'uid';
  static const PROFILE_PIC = 'profilePic';
  static const STREET = 'street';
  static const NUMOFPETS = 'numofpets';
  static const CITY = 'city';
  static const STATE = 'state';
  static const LEVEL = 'level';
  static const PROFILELIST_COLLECTION = 'providerlist';
  static const BOARDINGRATE = 'boardingRate';
  static const WALKINGRATE = 'walkingRate';
  static const DAYCARERATE = 'dayCare';
  static const DROPINRATE = 'dropInVisit';
  static const HOUSESITTINGRATE = 'houseSitting';
  static const LATI = 'lati';
  static const LONGTI = 'longti';
  static const SEARCHADD = 'searchAdd';
}