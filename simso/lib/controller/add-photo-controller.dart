import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simso/model/entities/user-model.dart';
import '../view/add-photo-page.dart';

class AddPhotoController {
  AddPhotoState state;
  UserModel newUser = UserModel();
  PermissionStatus status;
  //BuildContext context;

  AddPhotoController(this.state);

  // void displayOptionsDialog() async {
  //   await optionsDialogBox();
  // }

  void setState(Function fn) {
    setState(fn);
  }


  void askPermission() {
    print('permission');
    PermissionHandler()
        .requestPermissions([PermissionGroup.camera]).then(onStatusRequested);
    print('permission 2');
  }

  void onStatusRequested(Map<PermissionGroup, PermissionStatus> value) {
    final status = value[PermissionGroup.camera];
    if (status == PermissionStatus.granted) {
      print('status request');
      imageSelectorCamera();
    } else {
      print('status processing');
      updateStatus(status);
      print('status request complete');
    }
  }

  void updateStatus(PermissionStatus value) {
    print('enter status update');
    if (value != status) {
      print('setState');
      setState(() {
        status = value;
      });
      print('setState complete');
    }
  }

  void imageSelectorCamera() async {
    print('camera');
    Navigator.pop(state.context);
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
  }

  void imageSelectorGallery() async {
    print('gallery');
    Navigator.pop(state.context);
    print('gallery2');
    var imageFile1 = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    print('gallery3');
  }
}