import 'dart:io';

import 'package:PawPrint/controller/petprofile_controller.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PetProfile extends StatefulWidget {
  final bool sharedWithMe;
  final Pet pet;
  final User user;

  PetProfile(this.user, this.pet, this.sharedWithMe);

  @override
  State<StatefulWidget> createState() {
    return PetProfileState(user, pet, sharedWithMe);
  }
}

class PetProfileState extends State<PetProfile> {
  bool sharedWithMe;
  Pet pet;
  bool editMode = false;
  bool uploadmode = false;
  bool setPic = false;
  File image;
  StorageUploadTask uploadTask;
  String picPreview;
  User user;
  var formKey = GlobalKey<FormState>();
  BuildContext context;
  PetProfileController controller;
  PetProfileState(this.user, this.pet, this.sharedWithMe) {
    controller = PetProfileController(this);
  }
  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('${pet.petName}`s Profile',style: TextStyle(fontSize: 30,fontFamily: 'Modak'),),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: <Widget>[
          Column(children: <Widget>[
            CircleAvatar(
              child:
                  (pet.petPic == '' || pet.petPic == null || pet.petPic.isEmpty)
                      ? Text(
                          'No image selected',
                          style: TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                        )
                      : null,
              backgroundImage:
                  (pet.petPic == '' || pet.petPic == null || pet.petPic.isEmpty)
                      ? null
                      : NetworkImage(pet.petPic),
              radius: 150,
            ),
          ]),
          editMode == false
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                              'Pet name: ',
                              style: TextStyle(fontSize: 20),
                            ),
                        Wrap(
                          children: <Widget>[
                            
                            Text('    ${pet.petName}', style: TextStyle(fontSize: 20))
                          ],
                        ),
                        Text(''),
                        Text(
                              'Pet Age:',
                              style: TextStyle(fontSize: 20),
                            ),
                        Wrap(
                          children: <Widget>[
                            
                            Text(
                              '    ${pet.petAge}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Text(''),
                        Text(
                              'Pet Type:',
                              style: TextStyle(fontSize: 20),
                            ),
                        Wrap(
                          children: <Widget>[
                            Text(
                              '    ${pet.petType}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Text(''),
                        Text(
                              'Pet Likes:',
                              style: TextStyle(fontSize: 20),
                            ),
                        Wrap(
                          children: <Widget>[
                            Text(
                              '    ${pet.petLikes}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Text(''),
                        Text(
                              'Pet Dislikes:',
                              style: TextStyle(fontSize: 20),
                            ),
                        Wrap(
                          children: <Widget>[
                            Text(
                              '    ${pet.petDislikes}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Text(''),
                        Text(
                              'Pet Talent:',
                              style: TextStyle(fontSize: 20),
                            ),
                        Wrap(
                          children: <Widget>[
                            Text(
                              '    ${pet.petTalents}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Text(''),
                        Text(
                              'Pet Owner:',
                              style: TextStyle(fontSize: 20),
                            ),
                        Wrap(
                          children: <Widget>[
                            Text(
                              '    ${pet.petOwner}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              : Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: pet.petName,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Display Name',
                          labelText: 'Display Name',
                        ),
                        validator: controller.validatePetName,
                        onSaved: controller.savePetName,
                      ),
                      TextFormField(
                        initialValue: pet.petAge.toString(),
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Age',
                          labelText: 'Age',
                        ),
                        validator: controller.validateAge,
                        onSaved: controller.saveAge,
                      ),
                      TextFormField(
                        initialValue: pet.petType,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Type',
                          labelText: 'Type',
                        ),
                        validator: controller.validatePetName,
                        onSaved: controller.saveType,
                      ),
                      TextFormField(
                        initialValue: pet.petLikes,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Likes',
                          labelText: 'Likes',
                        ),
                        validator: controller.validatePetName,
                        onSaved: controller.saveLikes,
                      ),
                      TextFormField(
                        initialValue: pet.petDislikes,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Dislikes',
                          labelText: 'Dislikes',
                        ),
                        validator: controller.validatePetName,
                        onSaved: controller.saveDislikes,
                      ),
                      TextFormField(
                        initialValue: pet.petTalents,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Talents',
                          labelText: 'Talents',
                        ),
                        validator: controller.validatePetName,
                        onSaved: controller.saveTalents,
                      ),
                    ],
                  ),
                ),
          editMode != false
              ? Column(
                  children: <Widget>[
                    Text('Take a picture: '),
                    FlatButton(
                      onPressed: controller.takeImage,
                      child: Icon(Icons.camera),
                    ),
                    Text('Upload Picture from gallary: '),
                    FlatButton(
                      onPressed: controller.getImage,
                      child: Icon(Icons.photo_library),
                    ),
                  ],
                )
              : Text(''),
          uploadmode == true
              ? (Column(
                  children: <Widget>[
                    FlatButton.icon(
                      label: Text(
                        'Upload to Firebase Storage',
                        style: TextStyle(color: Colors.green),
                      ),
                      icon: Icon(Icons.cloud_upload),
                      onPressed: controller.startUpload,
                    ),
                    // Preview the picture
                    setPic == false
                        ? CircleAvatar(
                            child: Text('Preview'),
                            backgroundImage: FileImage(image),
                            radius: 80,
                          )
                        : Text(''),
                    setPic == true
                        ? FlatButton.icon(
                            label: Text('Set Picture'),
                            icon: Icon(Icons.send),
                            onPressed: controller.getUrl,
                          )
                        : Text('')
                  ],
                ))
              : Text(''),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              editMode == false
                  ? Text('')
                  : RaisedButton(
                      child: Text('Cancel'),
                      onPressed: controller.cancelEdit,
                    ),
              sharedWithMe == true ? Text(''):
              RaisedButton(
                onPressed: controller.editMode,
                child: editMode == false ? Text('Edit') : Text('Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
