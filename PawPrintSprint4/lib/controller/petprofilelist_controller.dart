import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/view/addpet.dart';
import 'package:PawPrint/view/petprofile.dart';
import 'package:PawPrint/view/petprofileList.dart';
import 'package:flutter/material.dart';

class PetProfileListController{
  PetProfileListState state;
  PetProfileListController(this.state);

//*********** profile does not update when adding new pet */

  void addPet() async {
    Pet pet = await Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => AddPetPage(state.user, null),
    ));
    if (pet!=null) {state.petList.add(pet);}
  }

  onTap(int index) async {
    if (state.deleteIndices == null) {
      Pet pet = await Navigator.push(
          state.context,
          MaterialPageRoute(
              builder: (context) =>
                  PetProfile(state.user, state.petList[index], state.sharedmode)));
      if (pet != null) {
        //updated book is stored in Firebase
        state.petList[index] = pet;
      }
    }else{
      //add to delete list
      if (state.deleteIndices.contains(index)){
        //tapped again deselect
        state.deleteIndices.remove(index);
        if (state.deleteIndices.length == 0){
          //all deselected. delete mode quits
          state.deleteIndices = null;
          state.deleteMode = false;
        }
      }else{
        state.deleteIndices.add(index);
      }
      state.stateChanged((){});
    }
  }

  onLongPress(int index) {
    if (state.deleteIndices == null) {
      state.deleteIndices = <int>[index];
      state.stateChanged(() {
        state.deleteIndices = <int>[index];
        state.deleteMode = true;
      });
    }
  }

  void delete() {
    state.deleteIndices.sort((n1,n2){
      if (n1 < n2) return 1;
      else if (n1 == n2)return 0;
      else return -1;
    });
    for (var i in state.deleteIndices){
      MyFirebase.deletePet(state.petList[i]);
        state.petList.removeLast();
    }
    state.stateChanged((){
      state.user.numOfPets = state.deleteIndices.length;
      state.deleteMode=false;
      state.deleteIndices.clear();
      state.deleteIndices = null;
    });
    MyFirebase.createProfile(state.user);
  }
}