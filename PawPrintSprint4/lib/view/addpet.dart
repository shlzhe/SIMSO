import 'package:PawPrint/controller/addpet_controller.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/user.dart';
import 'package:flutter/material.dart';

class AddPetPage extends StatefulWidget{
  final User user;
  final Pet pet;
  AddPetPage(this.user,this.pet);
  @override
  State<StatefulWidget> createState() {
    return AddPetPageState(user, pet);
      }
    
    }
    
    class AddPetPageState extends State<AddPetPage>{
      User user;
      BuildContext context;
      AddPetController controller;
      Pet pet;
      Pet petCopy;
      var formKey = GlobalKey<FormState>();
      AddPetPageState(this.user, this.pet){
        controller = AddPetController(this);
        if (pet==null){
          petCopy = Pet.empty();
        }
        else{
          petCopy= Pet.clone(pet);
        }
      }
      void onChange(Function f){
        setState(f);
      }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Pet'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
//Profile Picture textformfield removed... upload in profile.
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Pet Name',
                labelText: 'Pet Name',
              ),
              validator: controller.validatePetName,
              onSaved: controller.savePetName,
            ),
            TextFormField(
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Pet Age',
                labelText: 'Pet Age',
              ),
              validator: controller.validatePetAge,
              onSaved: controller.savePetAge,
            ),
            TextFormField(
              autocorrect: true,
              decoration: InputDecoration(
                hintText: 'Pet Likes',
                labelText: 'Pet Likes',
              ),

              onSaved: controller.savePetLikes,
            ),
            TextFormField(
              autocorrect: true,
              decoration: InputDecoration(
                hintText: 'Pet Dislikes',
                labelText: 'Pet Dislikes',
              ),
              onSaved: controller.savePetDislikes,
            ),
            TextFormField(
              autocorrect: true,
              decoration: InputDecoration(
                hintText: 'Pet Type',
                labelText: 'Pet Type',
              ),
              validator: controller.validatePetType,
              onSaved: controller.savePetType,
            ),
            TextFormField(
              autocorrect: true,
              decoration: InputDecoration(
                hintText: 'Pet Talents',
                labelText: 'Pet Talents',
              ),
              onSaved: controller.savePetTalents,
            ),
            RaisedButton(
              child: Text('Add Pet!'),
              onPressed: controller.createAddPet,
            )
          ],
        ),
      ),
    );
  }
}