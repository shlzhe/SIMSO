import 'dart:io';
import 'package:flutter/services.dart';
//import '../controller/myfirebase.dart';
//import 'package:file_picker/file_picker.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../view/add-music-page.dart';
import '../view/mydialog.dart';

class AddMusicController {
  // bookpage state obj as instance member
  AddMusicState state;
  String _extension;
  //FileType _fileType = FileType.AUDIO;
  dynamic songPath;
  //List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  // constructor receives state obj
  AddMusicController(this.state);

  String validateArtworkUrl(String value) {
    if (value == null || value.length < 5) {
      return 'Enter Image URL beginning with http';
    }
    return null;
  }

  void saveArtworkUrl(String value) {
    //state.songCopy.artWork = value;
  }

  String validateTitle(String value) {
    if (value == null || value.length < 2) {
      return 'Enter song title';
    }
    return null;
  }

  void saveTitle(String value) {
    //state.songCopy.title = value;
  }

  String validateArtist(String value) {
    if (value == null || value.length < 3) {
      return 'Enter song artist';
    }
    return null;
  }

  void saveArtist(String value) {
    //state.songCopy.artist = value;
  }

  String validateFeatArtist(String value) {
    // empty, or after leading/trailing blanks, still empty
    // its good not sharing
    if (value == null || value.trim().isEmpty) {
      return null; // not sharing
    }
    // comma seperated list comes in, chk if its email
    // use comma as token split long list
    // for (var email in value.split(',')) {
    //   if (!(email.contains('.') && email.contains('@'))) {
    //     return 'Enter comma(,) seperated email list';
    //   }
    //   // if there is multiple @ signs, index from beginning
    //   // and the last same, those are same, than only 1
    //   // if diff theres more than 1 @
    //   if (email.indexOf('@') != email.lastIndexOf('@')) {
    //     return 'Enter comma(,) seperated email list';
    //   }
    // }
    return null;
  }

  void saveFeatArtist(String value) {
    if (value == null || value.trim().isEmpty) {
      //value = "none";
      return; // dont do anything
    }
    //state.songCopy.featArtist = null;
    // value one long list, we split with func call
    // and generate a list of string type email list
    // one long string converted to list, and each element is an email
    List<String> featArtistlist = value.split(',');
    for (var featArtist in featArtistlist) {
      // trim the leading/trailing whitespaces in each email seperated by comma
      // add in sharewith list
      // state.songCopy.featArtist.add(featArtist.trim());
    }
  }

  String validateGenre(String value) {
    if (value == null || value.length < 3) {
      return 'Enter song genre';
    }
    return null;
  }

  void saveGenre(String value) {
    // state.songCopy.genre = value;
  }

  String validatePubyear(String value) {
    if (value == null || value == '0') {
      return 'Enter publication year';
    }
    // try to convert if its int or not
    try {
      int.parse(value);
    } catch (e) {
      // not a num
      return 'Enter publication year in numbers';
    }
    return null;
  }

  void savePubyear(String value) {
    // state.songCopy.pubyear = int.parse(value);
  }

  String validateSharedWith(String value) {
    // empty, or after leading/trailing blanks, still empty
    // its good not sharing
    if (value == null || value.trim().isEmpty) {
      return null; // not sharing
    }
    // comma seperated list comes in, chk if its email
    // use comma as token split long list
    for (var email in value.split(',')) {
      if (!(email.contains('.') && email.contains('@'))) {
        return 'Enter comma(,) seperated email list';
      }
      // if there is multiple @ signs, index from beginning
      // and the last same, those are same, than only 1
      // if diff theres more than 1 @
      if (email.indexOf('@') != email.lastIndexOf('@')) {
        return 'Enter comma(,) seperated email list';
      }
    }
    return null;
  }

  void saveSharedWith(String value) {
    if (value == null || value.trim().isEmpty) {
      return; // dont do anything

    }
    // state.songCopy.sharedWith = [];
    // value one long list, we split with func call
    // and generate a list of string type email list
    // one long string converted to list, and each element is an email
    List<String> emaillist = value.split(',');
    for (var email in emaillist) {
      // trim the leading/trailing whitespaces in each email seperated by comma
      // add in sharewith list
      //  state.songCopy.sharedWith.add(email.trim());
    }
  }

  String validateReview(String value) {
    if (value == null || value.length < 5) {
      return 'Enter book review (min 5 chars)';
    }
    return null;
  }

  void saveReview(String value) {
    // state.songCopy.review = value;
  }

  Future chooseSong() async {
    try {
      //   var song = await FilePicker.getFilePath(
      //      type: _fileType, fileExtension: _extension);
      //source: ImageSource.gallery); /*.then((image)*/
      state.stateChanged(() {
        //    state.audio = song;
        state.songLoaded = true;
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  Future uploadSong() async {
    String fileName = state.audio.split('/').last;
    String filePath = state.audio;

    _extension = fileName.toString().split('.').last;
    // StorageReference storageRef =
    //     FirebaseStorage.instance.ref().child('Songs/$fileName');
    // StorageUploadTask uploadTask = storageRef.putFile(
    //   File(filePath),
    //  StorageMetadata(
    //    contentType: '$_fileType/$_extension',
    //  ),
    // );
    //  StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    // state.stateChanged(() {
    //   _tasks.add(uploadTask);
    // });
    // StorageReference storageReference = FirebaseStorage.instance
    //     .ref()
    //     .child('Profiles/${Path.basename(state.image.path)}');
    // StorageUploadTask uploadTask = storageReference.putFile(state.image);
    // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    // state.stateChanged(() {
    //   print("Image uploaded!");
    //   MyDialog.info(
    //     context: state.context,
    //     title: 'Profile Image Upload Success',
    //     message: 'Press <Ok> to Navigate to ProfileScreen',
    //     action: () {
    //       Navigator.pop(state.context); // dispose this dialog
    //     },
    //   );
    //   // Scaffold.of(state.context)
    //   //     .showSnackBar(SnackBar(content: Text('Profile Image Uploaded')));
    // });

    //   storageRef.getDownloadURL().then((fileURL) async {
    // songPath = fileURL;
    // print("songPath: " + songPath);
    // state.stateChanged(() {
    //   //state.uploadedFileURL = fileURL;
    //   //print("uploadedFileURL is " + state.uploadedFileURL);
    //   state.song.songURL = fileURL;
    //   state.formKey.currentState.save();
    //   print("Song URL is " + state.song.songURL);
    // });
    //    await MyFirebase.updateSongURL(fileURL, state.songCopy);
    //    print("songURL: " + state.songCopy.songURL);
    //  });
  }
  // uploadToFirebase() {
  //   // if (_multiPick) {
  //   //     _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
  //   // } else {
  //   String fileName = state.audio.split('/').last;
  //   String filePath = state.audio;
  //   upload(fileName, filePath);
  //   //}
  // }

  // upload(fileName, filePath) async {
  //   _extension = fileName.toString().split('.').last;
  //   StorageReference storageRef =
  //       FirebaseStorage.instance.ref().child(fileName);
  //   final StorageUploadTask uploadTask = storageRef.putFile(
  //     File(filePath),
  //     StorageMetadata(
  //       contentType: '$_fileType/$_extension',
  //     ),
  //   );
  //   state.stateChanged(() {
  //     _tasks.add(uploadTask);
  //   });

  //   final String url = await storageRef.getDownloadURL();
  //   final http.Response downloadData = await http.get(url);
  //   final Directory systemTempDir = Directory.systemTemp;
  //   final File tempFile = File('${systemTempDir.path}/tmp.jpg');
  //   if (tempFile.existsSync()) {
  //     await tempFile.delete();
  //   }
  //   await tempFile.create();
  //   final StorageFileDownloadTask task = storageRef.writeToFile(tempFile);
  //   final int byteCount = (await task.future).totalByteCount;
  //   var bodyBytes = downloadData.bodyBytes;
  //   final String name = await storageRef.getName();
  //   final String path = await storageRef.getPath();
  //   print(
  //     'Success!\nDownloaded $name \nUrl: $url'
  //     '\npath: $path \nBytes Count :: $byteCount',
  //   );
  //   state.stateChanged(() {
  //     state.song.songURL = bodyBytes;
  //     print("songURL: " + state.song.songURL);
  //   });
  // }

  Future add() async {
    // fails return nothing
    // documentId comes from this call and saved

    try {
      if (state.audio == null) {
        MyDialog.info(
          context: state.context,
          title: 'No Songs Chosen',
          message: 'Please select a song to load',
          action: () {
            Navigator.pop(state.context);
            // b null, storing failed
            //Navigator.pop(state.context, null);
          },
        );
      } else {
        if (!state.formKey.currentState.validate()) {
          return;
        }

        state.formKey.currentState.save();

        //     state.songCopy.createdBy = state.user.email;
        //     state.songCopy.lastUpdatedAt = DateTime.now();

        // check firebase addbook successful or not
        //     try {
        //      if (state.song == null) {
        // addButton to add book if empty
        //        state.songCopy.songId = await MyFirebase.addSong(state.songCopy);
        //      } else {
        // from homepage to edit a book
        //         await MyFirebase.updateSong(state.songCopy);
      }

      // pass a value back to caller, which is 2nd argument
      // book just stored in firestore
      // using 2nd arg, caller in homepage addbutton could receive return val
      //      Navigator.pop(state.context, state.songCopy);
    } catch (e) {
      // if any error occur in firestore, than give null val
      // b in homepage add is null, it wasnt successfully store
      MyDialog.info(
        context: state.context,
        title: 'Firestore Save Error',
        message: 'Firestore is unavailable now. Try again later',
        action: () {
          Navigator.pop(state.context);
          // b null, storing failed
          Navigator.pop(state.context, null);
        },
      );
    }
    await uploadSong();
  }
  //  } catch (e) {
  //    MyDialog.info(
  //     context: state.context,
  //     title: 'Firestore Save Error',
  //     message: 'Firestore is unavailable now. Try again later',
  //     action: () {
  //       Navigator.pop(state.context);
  //       // b null, storing failed
  //       Navigator.pop(state.context, null);
  //     },
  //   );
  // }
  // state.stateChanged(() {
  //   state.audio = null;
  // });
}
//}
