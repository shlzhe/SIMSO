import 'dart:io';
import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/model/user.dart';
import 'package:PawPrint/view/manageuser.dart';
import 'package:PawPrint/view/profilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_saver/image_picker_saver.dart' as saver;

class ProfilePageController {
  ProfilePageState state;
  ProfilePageController(this.state);
  String filePath;
  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://pawprintmatermproj.appspot.com');
  Future takeImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      var filePath = await saver.ImagePickerSaver.saveFile(
          fileData: image.readAsBytesSync());
      var savedFile = File.fromUri(Uri.file(filePath));
      state.stateChanged(() {
        state.image = savedFile;
        // Get a reference to the storage service, which is used to create references in your storage bucket
      });
    }
  }
  File imageFile;
  void getImage() async {
    filePath ='images/${state.user.email}.png';
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state.uploadmode=true;
      state.stateChanged(() {
        // state.image = image;
        print(image.toString());
      });
    }
    print('~~~~~~~~~~~~~~~~~~~~');
    face(image);

  }
  void face(var image) async{
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final List<Face> faces = await faceDetector.processImage(visionImage);
    state.stateChanged((){
      state.images = faces;
    });
  }
  Future editMode() async {
    if (state.editMode == false)
      state.stateChanged(() {

        state.editMode = true;
      });
    else{
      if (!state.formKey.currentState.validate()){
        return;
      }
        state.formKey.currentState.save();
        //---------
        //Convert address to coordinates

       var address = await Geocoder.local.findAddressesFromQuery(state.user.street +','+ state.user.city +','+ state.user.state +','+ state.user.zip.toString());
       var first = address.first;
       print("${first.featureName}: ${first.coordinates} in frontPage_controller");
        
       state.user.lati = first.coordinates.latitude.toString();
       state.user.longti = first.coordinates.longitude.toString();

       // Update coordinates in Firestore
       //FIRST, find the docID of the user
       try{
                  QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILE_COLLECTION).
         where('email', isEqualTo: state.user.email).getDocuments();
         
         if(querySnapshot==null || querySnapshot.documents.length == 0){
           print('no docID found');
         }
        for(DocumentSnapshot doc in querySnapshot.documents){
        print('Selected docID: ${doc.documentID}');
                print('Selected docID: ${doc.documentID}');
        
        //UPDATE COORDINATES IN FIRESTORE EVEYTIME THE USER LOG IN
        await Firestore.instance.collection('userprofile')
        .document(doc.documentID).updateData({
          'lati': state.user.lati,
          'longti': state.user.longti, 
          'street': state.user.street,
          'city': state.user.city,
          'state': state.user.state,
          'zip': state.user.zip,
          'displayName': state.user.displayName,
          });        
        }
       }
       catch(e){
         throw e;}

        //---------
        //AFTER UPDATE LATI AND LONGTI IN USERPROFILE
    //NOW SET LATI AND LONGTI IN PROVIDERLIST
    //---------------------------------------------
       try{
         QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILELIST_COLLECTION).
         where('email', isEqualTo: state.user.email).getDocuments();
         
         if(querySnapshot==null || querySnapshot.documents.length == 0){
           print('no docID found');
         }
         for(DocumentSnapshot doc in querySnapshot.documents){
        print('Selected provider in providerlist: ${doc.documentID}');
        
        //UPDATE COORDINATES IN FIRESTORE EVEYTIME THE USER LOG IN
        await Firestore.instance.collection('providerlist')
        .document(doc.documentID).updateData({
          'lati': state.user.lati,
          'longti': state.user.longti,
          'street': state.user.street,
          'city': state.user.city,
          'state': state.user.state,
          'zip': state.user.zip,
          'displayName': state.user.displayName
          });

 
               }
            
       }
       catch(e){
         throw e;}
    //---------------------------------------------






        state.stateChanged(() {
          // if (url != null){
          //   state.user.profilePic=url;
          //   print(state.user.profilePic);
          // }
          state.editMode = false;
          state.uploadmode = false;
        //make changes to profile
        MyFirebase.createProfile(state.user);
        MyFirebase.createProviderList(state.user);
      });}
  }

   startUpload() {
    print(state.user.profilePic.length);
    if (state.user.profilePic.length != 0){
      _storage.ref().child(filePath).delete().whenComplete(upload);
    }
    else upload();
    editMode();
  }
  void upload(){
    state.uploadTask = _storage.ref().child(filePath).putFile(state.image);
    state.stateChanged((){
      state.setPic = true;
    });
    
  }
  void getUrl(){
    _storage.ref().child(filePath).getDownloadURL()
      .then((url){
        state.stateChanged((){
          state.user.profilePic = url;
        });
        MyFirebase.createProfile(state.user);
        MyFirebase.createProviderList(state.user);
      });
    state.setPic=false;
    state.uploadmode = false;
  }
  void cancelEdit() {
    state.stateChanged(() {
      state.setPic = state.editMode = false;
    });
  }

  String validateDisplayName(String name) {
    if (name == null || name.length < 2){
      return 'Enter at least 2 chars';
    }
    else return null;
  }

  void saveDisplayName(String name) {
    state.user.displayName = name;
  }

  String validateZip(String zip) {
    if (zip == null || zip.length != 5){
      return 'Enter 5 digit zip code';
    }
    try{
      int n = int.parse(zip);
      if (n<10000){
        return 'Enter 5 digit zip code';
      }
    }
    catch(e){
      return 'Enter 5 digit zip code';
    }
    return null;
  }

  void saveZip(String zip) {
    state.user.zip = int.parse(zip);
  }


   gotoManageUser() async {
    List<User> userList = await MyFirebase.getUserList();
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context)=> ManageUserPage(userList),
    ));
  }

  void saveStreet(String newValue) {
    state.user.street = newValue;
  }

  void saveCity(String newValue) {
    state.user.city = newValue;
  }

  void saveState(String newValue) {
    state.user.state = newValue;
  }

  void saveNumOfPets(String newValue) {
    state.user.numOfPets = int.parse(newValue);
  }

  String validateNumOfPets(String value) {
    if (value ==null || value.isEmpty) state.user.numOfPets=0;
    else{
      try {
        state.user.numOfPets = int.parse(value);
      } catch (e) {
        return 'Cannot convert Number of Pets field';
      }
    }
    return null;
  }

  void saveBoarding(String newValue) {
    state.user.boardingRate = double.parse(newValue);
  }

  void saveWalking(String newValue) {
    state.user.walkingRate = double.parse(newValue);
  }

  void saveDayCare(String newValue) {
    state.user.dayCare = double.parse(newValue);
  }

  void saveDropIn(String newValue) {
    state.user.dropInVisit = double.parse(newValue);
  }

  void saveHouseSitting(String newValue) {
    state.user.houseSitting = double.parse(newValue);
  }
}
