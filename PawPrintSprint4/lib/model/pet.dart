class Pet{
  String petOwner;
  String petName;
  String petLikes;
  String petDislikes;
  int petAge;
  String petType;
  String petTalents;
  String documentID;
  List<dynamic> sharedWith;
  String petPic;
  

  String uid; //uid in Firestore 

  //Creative 

  //Pet constructor
  Pet({
    this.uid,
    this.petPic,
    this.petOwner,
    this.petName,
    this.petLikes,
    this.petDislikes,
    this.petAge,
    this.petType,
    this.petTalents,
    this.sharedWith,
  });
  Pet.empty(){
    this.uid = '';
    this.petPic = '';
    this.petOwner = '';
    this.petName='';
    this.petLikes='';
    this.petDislikes='';
    this.petAge=0;
    this.petType='';
    this.petTalents='';
    this.sharedWith=<dynamic>[];
  }
  Pet.clone(Pet pet){
    this.petPic = pet.petPic;
    this.documentID = pet.documentID;
    this.petOwner = pet.petOwner;
    this.petName = pet.petName;
    this.petAge = pet.petAge;
    this.petLikes = pet.petLikes;
    this.petDislikes = pet.petDislikes;
    this.petType = pet.petType;
    this.petTalents = pet.petTalents;
    this.uid = pet.uid;
    this.sharedWith = <dynamic>[]..addAll(pet.sharedWith);
  }

  Map<String, dynamic> serialize(){
      return <String,dynamic>{
        PETOWNER: petOwner,
        PETNAME: petName,
        PETDISLIKES: petDislikes,
        PETLIKES: petLikes,
        PETAGE: petAge,
        PETTYPE: petType,
        PETTALENTS: petTalents,
        SHAREDWITH: sharedWith,
        UID: uid,
        PETPIC: petPic,
      };
  }

  static Pet deserialize (Map<String,dynamic> document, String docId){
    var pet = Pet(
      uid: document[UID],
      petOwner: document[PETOWNER],
      petName: document [PETNAME],
      petLikes: document [PETLIKES],
      petDislikes: document [PETDISLIKES],
      petAge: document [PETAGE],
      petType: document [PETTYPE],
      petTalents: document[PETTALENTS],
      sharedWith: document[SHAREDWITH],
      petPic: document[PETPIC],
    );
    pet.documentID = docId;
    return pet;
  }

  //petLikes is saved in authentication
  static const PET_COLLECTION = 'petprofile';
  static const UID = 'uid';
  static const PETOWNER = 'owner';
  static const PETNAME = 'petName';
  static const PETLIKES = 'petLikes';
  static const PETDISLIKES = 'petDislikes';
  static const PETAGE = 'petAge';
  static const PETTYPE = 'petType';
  static const PETTALENTS = 'petTalents';
  static const SHAREDWITH = 'sharedWith';
  static const PETPIC = 'petPic';
}