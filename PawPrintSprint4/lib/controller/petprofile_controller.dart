import 'dart:io';

import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/view/petprofile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_saver/image_picker_saver.dart' as saver;

class PetProfileController {
  PetProfileState state;
  PetProfileController(this.state);

  String validatePetName(String value) {
    if (value == null || value.length < 2){
      return 'Enter at least 2 chars';
    }
    else return null;
  }

  void savePetName(String newValue) {
    state.pet.petName = newValue;
  }

  String validateAge(String value){
    if (value.length < 1){
      return 'Enter 5 digit zip code';
    }
    try{
      int n = int.parse(value);
      if (n==null){
        return 'You have not entered an age.';
      }
    }
    catch(e){
      return 'You have not entered a valid number.';
    }
    return null;
  }

  void saveAge(String newValue) {
    state.pet.petAge = int.parse(newValue);
  }

  void saveType(String newValue) {
    state.pet.petType = newValue;
  }

  void saveLikes(String newValue) {
    state.pet.petLikes = newValue;
  }

  void saveDislikes(String newValue) {
    state.pet.petDislikes = newValue;
  }

  void saveTalents(String newValue) {
    state.pet.petTalents = newValue;
  }

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
  void getImage() async {
    filePath ='images/${state.user.email+state.pet.petName}.png';
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      state.uploadmode=true;
      state.stateChanged(() {
        state.image = image;
        print(image.toString());
      });
    }    
  }

  void editMode() {
    if (state.editMode == false)
      state.stateChanged(() {

        state.editMode = true;
      });
    else{
      if (!state.formKey.currentState.validate()){
        return;
      }
        state.formKey.currentState.save();
        
        state.stateChanged(() {
          state.editMode = false;
          state.uploadmode = false;
      });}
        //make changes to profile
        MyFirebase.createProfile(state.user);
        MyFirebase.updatePetProfile(state.user, state.pet);
  }
   startUpload() {
    if (state.pet.petPic != ''){
      _storage.ref().child(filePath).delete().whenComplete(upload);
    }
    else {
      upload();
    
    }
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
          state.pet.petPic = url;
        });
        MyFirebase.updatePetProfile(state.user, state.pet);
      });
    state.setPic=false;
    state.uploadmode = false;
  }
  void cancelEdit() {
    state.stateChanged(() {
      state.setPic = state.editMode = false;
    });
  }  
}