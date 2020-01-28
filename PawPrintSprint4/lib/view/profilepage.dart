import 'dart:io';
import 'package:PawPrint/controller/profile_controller.dart';
import 'package:PawPrint/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  ProfilePage(this.user);
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(user);
  }
}

class ProfilePageState extends State<ProfilePage> {
  bool editMode = false;
  bool uploadmode = false;
  bool setPic = false;
  File image;
  var images;
  StorageUploadTask uploadTask;
  String picPreview;
  User user;
  var formKey = GlobalKey<FormState>();
  BuildContext context;
  ProfilePageController controller;
  void stateChanged(Function f) {
    setState(f);
  }

  ProfilePageState(this.user) {
    controller = ProfilePageController(this);
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.displayName}`s Profile',style: TextStyle(fontSize: 30,fontFamily: 'Modak'),),
          backgroundColor: Colors.green,
        actions: <Widget>[
          user.level == 'admin'
              ? FlatButton.icon(
                  label: Text('Manage User'),
                  icon: Icon(Icons.people),
                  onPressed: controller.gotoManageUser,
                )
              : Text(''),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        child: (user.profilePic == '' ||
                                user.profilePic == null ||
                                user.profilePic.isEmpty)
                            ? Text(
                                'No image selected',
                                style: TextStyle(fontSize: 40),
                                textAlign: TextAlign.center,
                              )
                            : null,
                        backgroundImage: (user.profilePic == '' ||
                                user.profilePic == null ||
                                user.profilePic.isEmpty)
                            ? null
                            : NetworkImage(user.profilePic),
                        radius: 150,
                      ),
                    ]),
              ),
              editMode == false
                  ?
                  // padding: EdgeInsets.only(left: 110, top: 20, bottom: 20),
                  Column(
                      children: <Widget>[
                        Text(
                          'Display name: ${user.displayName}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'User Level: ${user.level}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Street: ${user.street}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'City: ${user.city}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Street: ${user.state}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Zip: ${user.zip}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Number of pets: ${user.numOfPets}',
                          style: TextStyle(fontSize: 20),
                        ),
                        user.level != 'provider'
                            ? Text('')
                            : Column(
                                children: <Widget>[
                                  Text(
                                    '\nRates:',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Boarding: ${user.boardingRate}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Walking: ${user.walkingRate}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Day Care: ${user.dayCare}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Drop in Visits: ${user.dropInVisit}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'House Sitting: ${user.houseSitting}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              )
                      ],
                    )
                  : Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: user.displayName,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Display Name',
                              labelText: 'Display Name',
                            ),
                            validator: controller.validateDisplayName,
                            onSaved: controller.saveDisplayName,
                          ),

                          TextFormField(
                            initialValue: user.street,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Street',
                              labelText: 'Street',
                            ),
                            validator: controller.validateDisplayName,
                            onSaved: controller.saveStreet,
                          ),
                          TextFormField(
                            initialValue: user.city,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'City',
                              labelText: 'City',
                            ),
                            validator: controller.validateDisplayName,
                            onSaved: controller.saveCity,
                          ),
                          TextFormField(
                            initialValue: user.state,
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'State',
                              labelText: 'State',
                            ),
                            validator: controller.validateDisplayName,
                            onSaved: controller.saveState,
                          ),
                          TextFormField(
                            initialValue: user.zip.toString(),
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Zip',
                              labelText: 'Zip',
                            ),
                            validator: controller.validateZip,
                            onSaved: controller.saveZip,
                          ),
                          TextFormField(
                            initialValue: user.numOfPets.toString(),
                            autocorrect: false,
                            decoration: InputDecoration(
                              hintText: 'Number of Pets',
                              labelText: 'Number of Pets',
                            ),
                            validator: controller.validateNumOfPets,
                            onSaved: controller.saveNumOfPets,
                          ),
                          user.level != 'provider'
                              ? Text('')
                              : Column(
                                  children: <Widget>[
                                    TextFormField(
                                      initialValue:
                                          user.boardingRate.toString(),
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        hintText: User.BOARDINGRATE,
                                        labelText: User.BOARDINGRATE,
                                      ),
                                      onSaved: controller.saveBoarding,
                                    ),
                                    TextFormField(
                                      initialValue:
                                          user.walkingRate.toString(),
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        hintText: User.WALKINGRATE,
                                        labelText: User.WALKINGRATE,
                                      ),
                                      onSaved: controller.saveWalking,
                                    ),
                                    TextFormField(
                                      initialValue: user.dayCare.toString(),
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        hintText: User.DAYCARERATE,
                                        labelText: User.DAYCARERATE,
                                      ),
                                      onSaved: controller.saveDayCare,
                                    ),
                                    TextFormField(
                                      initialValue:
                                          user.dropInVisit.toString(),
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        hintText: User.DROPINRATE,
                                        labelText: User.DROPINRATE,
                                      ),
                                      onSaved: controller.saveDropIn,
                                    ),
                                    TextFormField(
                                      initialValue:
                                          user.houseSitting.toString(),
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        hintText: User.HOUSESITTINGRATE,
                                        labelText: User.HOUSESITTINGRATE,
                                      ),
                                      onSaved: controller.saveHouseSitting,
                                    ),
                                  ],
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
                  RaisedButton(
                    onPressed: controller.editMode,
                    child: editMode == false ? Text('Edit') : Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
