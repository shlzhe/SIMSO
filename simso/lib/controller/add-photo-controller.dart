import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/services/ipicture-service.dart';
import '../view/mydialog.dart';
import '../view/add-photo-page.dart';
import '../service-locator.dart';

class AddPhotoController {
  AddPhotoState state;
  //UserModel newUser = UserModel();
  String _extension;
  FileType _fileType = FileType.IMAGE;
  dynamic imagePath;
  IImageService imageService = locator<IImageService>();
  PermissionStatus status;
  //BuildContext context;

  AddPhotoController(this.state);

  String validateSummary(String value) {
    if (value == null || value.length < 5) {
      return 'Please enter a summary (5 or more chars)';
    }
    return null;
  }

  void saveSummary(String value) {
    state.imageCopy.summary = value;
  }

  Future uploadImage() async {
    String fileName = state.imagePath.split('/').last;
    String filePath = state.imagePath;
    _extension = fileName.toString().split('.').last;
    StorageReference storageRef = FirebaseStorage.instance
        .ref()
        .child('Images/${state.user.username}Images/$fileName');
    StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$_fileType/$_extension',
      ),
    );
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    storageRef.getDownloadURL().then((fileURL) async {
      await imageService.updateImageURL(fileURL, state.imageCopy);
    });
  }

  Future add() async {
    // fails return nothing
    // documentId comes from this call and saved
    try {
      if (state.imagePath == null) {
        MyDialog.info(
          context: state.context,
          title: 'No Image Chosen',
          message: 'Please take a picture',
          action: () {
            Navigator.pop(state.context);
            // b null, storing failed
            //Navigator.pop(state.context, null);
          },
        );
      } 
      
      else {
        if (!state.formKey.currentState.validate()) {
          return ;
        }

        state.formKey.currentState.save();
        print('saved');
        state.imageCopy.createdBy = state.user.email;
        state.imageCopy.ownerPic = state.user.profilePic;
        state.imageCopy.ownerID = state.user.uid;
        state.imageCopy.lastUpdatedAt = DateTime.now();
        // check firebase addbook to determine whether successful or not
        try {
          if (state.image == null) {
            // addButton to add song if empty
            state.imageCopy.imageId = await imageService.addImage(state.imageCopy);
          } else {
            // from homepage to edit a picture
            await imageService.updateImage(state.imageCopy);
          }

          // pass a value back to caller, which is 2nd argument
          // song just stored in firestore
          // using 2nd arg, caller in homepage addbutton could receive return val
          Navigator.pop(state.context, state.imageCopy);
        } catch (e) {
          // if any error occur in firestore, than give null val
          // b in homepage add is null, it wasnt successfully store
          MyDialog.info(
            context: state.context,
            title: 'Firestore Save Error',
            message: 'Firestore is unavailable now. Add Image Failed.',
            action: () {
              Navigator.pop(state.context);
              // b null, storing failed
              //Navigator.pop(state.context, null);
              print(e);
            },
          );
        }
        await uploadImage();
      }
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Firestore Save Error',
        message: 'Firestore is unavailable now. Upload Image Failed.',
        action: () {
          Navigator.pop(state.context);
          // b null, storing failed
          //Navigator.pop(state.context, null);
          print(e);
        },
      );
    }
  }

    


}