import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/view/addpet.dart';
import 'package:flutter/material.dart';

class AddPetController{
  AddPetPageState state;
  AddPetController(this.state);

  Future createAddPet() async {
    if (!state.formKey.currentState.validate()){
      return;
    }
    state.formKey.currentState.save();
    if (state.petCopy.petName != null){
      state.user.numOfPets++;
      state.petCopy.petOwner = state.user.email;
      state.petCopy.uid = state.user.uid;
      // updates user information
      MyFirebase.createProfile(state.user);
      MyFirebase.updatePetProfile(state.user, state.petCopy);

      // returns to Petprofile page.
      Navigator.pop(state.context, state.petCopy);
      }
  }

  String validatePetName(String value) {
    if (value == null || value.length < 2){
      return 'Please enter a pet Name';
    }
    return null;
  }

  void savePetName(String newValue) {
    state.onChange((){
      state.petCopy.petName = newValue;
    });
  }

  String validatePetAge(String value) {
    if (value == null){
      return 'Please enter the dog`s age.';
    }
    try{
      int.parse(value);
    }catch(error){
      return 'Invalid age: '; 
    }
    return null;
  }

  String savePetAge(String newValue) {
    state.onChange((){
      state.petCopy.petAge = int.parse(newValue);
    });
    return null;
  }

  void savePetLikes(String newValue) {
    state.onChange((){
      state.petCopy.petLikes = newValue;
    });
  }

  void savePetDislikes(String newValue) {
    state.onChange((){
      state.petCopy.petDislikes = newValue;
    });
  }

  void savePetType(String newValue) {
    state.onChange((){
      state.petCopy.petType = newValue;
    });
  }

  String validatePetType(String value) {
    if (value == null || value.length < 1){
      return 'Please enter a pet breed';
    }
    return null;
  }

  void savePetTalents(String newValue) {
    state.onChange((){
      state.petCopy.petTalents = newValue;
    });
  }
}