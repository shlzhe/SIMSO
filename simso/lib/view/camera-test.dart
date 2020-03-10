import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/user-model.dart';
import '../model/entities/image-model.dart';
import 'package:simso/view/design-constants.dart';
import '../controller/add-photo-controller.dart';

class AddPhoto extends StatefulWidget {

  final UserModel user;
  final ImageModel image;

  AddPhoto(this.user, this.image);

  @override
  State<StatefulWidget> createState() {
    return AddPhotoState();
  }
}

class AddPhotoState extends State<AddPhoto> {

  UserModel user;
  ImageModel image;
  //PermissionStatus status;
  AddPhotoController controller;
  var formKey = GlobalKey<FormState>();
  BuildContext context;

  // AddPhotoState(this.user, this.image) {
  //   controller = AddPhotoController();
  // }

  void stateChanged(Function fn) {
    setState(fn);
  }

  @override
  void initState() {
    super.initState();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera);
        //.then(controller.updateStatus);
  }

  @override
  Widget build(BuildContext context) {
    //this.context = context;
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
    },
    child:  Scaffold(
        appBar: AppBar(
          // Here we take the value from the AddPhotos object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("My Photos"),
          backgroundColor: DesignConstants.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.camera_alt),
                iconSize: 48,
                onPressed: () {
                  optionsDialogBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> optionsDialogBox() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          print('pic');
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take Photo'),
                    onTap: null,//controller.askPermission,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select Image From Gallery'),
                    onTap: null,//controller.imageSelectorGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }

}
