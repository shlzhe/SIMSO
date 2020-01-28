import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/saveservice.dart';
import 'package:PawPrint/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirebase {
  //Create account
  static Future<String> createAccount(
      {String email, String password, String profilePic}) async {
    AuthResult auth =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user.uid;
  }

  static void createProfile(User user) async {
    await Firestore.instance
        .collection(User.PROFILE_COLLECTION)
        .document(user.uid)
        .setData(user.serialize());
  }

  // static Future deleteUser(User user, String id) async {
  //   await Firestore.instance.collection(User.PROFILE_COLLECTION)
  //     .document(id)
  //     .delete();
  // }
  static void createOrder(OrderService order) async {
    await Firestore.instance
        .collection(OrderService.ORDEREDSERVICE)
        .document(order.providerEmail + order.dateTime)
        .setData(order.serialize());
  }

  static Future<List<OrderService>> getOrders(String email) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(OrderService.ORDEREDSERVICE)
        .where(OrderService.PROVIDEREMAIL, isEqualTo: email)
        .getDocuments();
    var orderList = <OrderService>[];
    print(querySnapshot.documents.length);
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return orderList;
    }
    for (DocumentSnapshot doc in querySnapshot.documents) {
      orderList.add(OrderService.deserialize(doc.data));
    }
    return orderList;
  }

  static void createProviderList(User user) async {
    await Firestore.instance
        .collection(User.PROFILELIST_COLLECTION)
        .document(user.email)
        .setData(user.serialize());
  }

  static void updatePetProfile(User user, Pet pet) async {
    print(pet.petName);
    await Firestore.instance
        .collection(Pet.PET_COLLECTION)
        .document(pet.petOwner + pet.petName)
        .setData(pet.serialize());
  }

  //Check if the username is on database after user clicked LOG IN button
  static Future<String> login({String email, String password}) async {
    //Define named variables of email/password
    AuthResult auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return auth.user
        .uid; //Read user/password, if username/password is in FireStore, return uid
  }

  static Future<User> readProfile(String uid) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection(User.PROFILE_COLLECTION)
        .document(uid)
        .get();
    return User.deserialize(doc.data);
  }

  static void signOut() {
    FirebaseAuth.instance.signOut();
  }

  //Creative
  static Future<void> resetPass(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<List<Pet>> getPetList(String email) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Pet.PET_COLLECTION)
        .where(Pet.PETOWNER, isEqualTo: email)
        .getDocuments();
    var petList = <Pet>[];
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return petList;
    }
    for (DocumentSnapshot doc in querySnapshot.documents) {
      petList.add(Pet.deserialize(doc.data, doc.documentID));
    }
    return petList;
  }

  static Future<List<Pet>> sharedPetList(String email) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(Pet.PET_COLLECTION)
        .where(Pet.SHAREDWITH, arrayContains: email)
        .getDocuments();
    var petList = <Pet>[];
    if (querySnapshot == null || querySnapshot.documents.length == 0) {
      return petList;
    }
    for (DocumentSnapshot doc in querySnapshot.documents) {
      petList.add(Pet.deserialize(doc.data, doc.documentID));
    }
    return petList;
  }

  static void addPet(Pet pet) async {
    await Firestore.instance
        .collection(Pet.PET_COLLECTION)
        .document(pet.petOwner + pet.petName)
        .setData(pet.serialize());
  }

  static Future deletePet(Pet pet) async {
    await Firestore.instance
        .collection(Pet.PET_COLLECTION)
        .document(pet.petOwner + pet.petName)
        .delete();
  }

  static Future<List<User>> getUserList() async {
    QuerySnapshot userSnapShot = await Firestore.instance
        .collection(User.PROFILE_COLLECTION)
        .where(User.LEVEL, isEqualTo: 'user')
        .getDocuments();
    var userList = <User>[];
    if (userSnapShot == null || userSnapShot.documents.length == 0) {
      return userList;
    }
    for (DocumentSnapshot doc in userSnapShot.documents) {
      userList.add(User.deserialize(doc.data));
    }
    QuerySnapshot providerSnapShot = await Firestore.instance
        .collection(User.PROFILE_COLLECTION)
        .where(User.LEVEL, isEqualTo: 'provider')
        .getDocuments();
    for (DocumentSnapshot doc in providerSnapShot.documents) {
      userList.add(User.deserialize(doc.data));
    }
    return userList;
  }

  static Future<List<User>> getProviderList() async {
    QuerySnapshot userSnapShot = await Firestore.instance
        .collection(User.PROFILE_COLLECTION)
        .where(User.LEVEL, isEqualTo: 'provider')
        .getDocuments();
    var userList = <User>[];
    if (userSnapShot == null || userSnapShot.documents.length == 0) {
      return userList;
    }
    for (DocumentSnapshot doc in userSnapShot.documents) {
      userList.add(User.deserialize(doc.data));
    }
    QuerySnapshot adminSnapShot = await Firestore.instance
        .collection(User.PROFILE_COLLECTION)
        .where(User.LEVEL, isEqualTo: 'admin')
        .getDocuments();
    for (DocumentSnapshot doc in adminSnapShot.documents) {
      userList.add(User.deserialize(doc.data));
    }
    return userList;
  }

  static Future deleteOrder(OrderService orderService, User user) async {
    await Firestore.instance
        .collection(OrderService.ORDEREDSERVICE)
        .document(user.email + orderService.dateTime)
        .delete();
  }

  static void disableAccount(String uid, String email) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection(User.PROFILE_COLLECTION)
        .document(uid)
        .get();
    User user = User.deserialize(doc.data);
    user.level = 'disabled';

    await Firestore.instance
        .collection(User.PROFILE_COLLECTION)
        .document(uid)
        .setData(<String, dynamic>{
      User.EMAIL: user.email,
      User.DISPLAYNAME: user.displayName,
      User.ZIP: user.zip,
      User.UID: user.uid,
      User.PROFILE_PIC: user.profilePic,
      User.STREET: user.street,
      User.NUMOFPETS: user.numOfPets,
      User.CITY: user.city,
      User.STATE: user.state,
      User.LEVEL: user.level,
      User.BOARDINGRATE: user.boardingRate,
      User.WALKINGRATE: user.walkingRate,
      User.DAYCARERATE: user.dayCare,
      User.DROPINRATE: user.dropInVisit,
      User.HOUSESITTINGRATE: user.houseSitting,
      User.LATI: user.lati,
      User.LONGTI: user.longti,
      User.SEARCHADD: user.searchAdd
    });
  }
}
