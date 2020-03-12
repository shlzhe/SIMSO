import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:simso/model/services/isong-service.dart';
import '../view/mydialog.dart';
import '../view/add-music-page.dart';
import '../service-locator.dart';

class AddMusicController {
  // bookpage state obj as instance member
  AddMusicState state;
  String _extension;
  FileType _fileType = FileType.AUDIO;
  dynamic songPath;
  ISongService _songService = locator<ISongService>();

  // constructor receives state obj
  AddMusicController(this.state);

  String validateArtworkUrl(String value) {
    if (value == null || value.length < 5) {
      return 'Enter Image URL beginning with http';
    }
    return null;
  }

  void saveArtworkUrl(String value) {
    state.songCopy.artWork = value;
  }

  String validateTitle(String value) {
    if (value == null || value.length < 2) {
      return 'Enter song title';
    }
    return null;
  }

  void saveTitle(String value) {
    state.songCopy.title = value;
  }

  String validateArtist(String value) {
    if (value == null || value.length < 3) {
      return 'Enter song artist';
    }
    return null;
  }

  void saveArtist(String value) {
    state.songCopy.artist = value;
  }

  String validateFeatArtist(String value) {
    // empty, or after leading/trailing blanks, still empty
    // its good not sharing
    if (value == null || value.trim().isEmpty) {
      return null; // not sharing
    }
    return null;
  }

  void saveFeatArtist(String value) {
    if (value == null || value.trim().isEmpty) {
      //value = "none";
      return; // dont do anything
    }
    //state.songCopy.featArtist = value;
    // value one long list, we split with func call
    // and generate a list of string type email list
    // one long string converted to list, and each element is an email
    List<String> featArtistlist = value.split(',');
    for (var featArtist in featArtistlist) {
      // trim the leading/trailing whitespaces in each email seperated by comma
      // add in sharewith list
      state.songCopy.featArtist.add(featArtist.trim());
      print("FEAT ARTIST: " + state.songCopy.featArtist.toString());
    }
  }

  String validateGenre(String value) {
    if (value == null || value.length < 3) {
      return 'Enter song genre';
    }
    return null;
  }

  void saveGenre(String value) {
    state.songCopy.genre = value;
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
    state.songCopy.pubyear = int.parse(value);
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
    state.songCopy.songPost = [];
    // value one long list, we split with func call
    // and generate a list of string type email list
    // one long string converted to list, and each element is an email
    List<String> emaillist = value.split(',');
    for (var email in emaillist) {
      // trim the leading/trailing whitespaces in each email seperated by comma
      // add in sharewith list
      state.songCopy.songPost.add(email.trim());
    }
  }

  String validateReview(String value) {
    if (value == null || value.length < 5) {
      return 'Enter song review (min 5 chars)';
    }
    return null;
  }

  void saveReview(String value) {
    state.songCopy.review = value;
  }

  Future chooseSong() async {
    try {
      var song = await FilePicker.getFilePath(
          type: _fileType, fileExtension: _extension);
      //source: ImageSource.gallery); /*.then((image)*/
      state.stateChanged(() {
        state.audio = song;
        if (state.audio == null || state.audio.trim().isEmpty) {
          state.songLoaded = false;
        } else {
          state.songLoaded = true;
        }
        print(state.audio);
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  Future uploadSong() async {
    print("*****FORMATTING SONG PATH*****");
    String fileName = state.audio.split('/').last;
    String filePath = state.audio;
    _extension = fileName.toString().split('.').last;
    print("*****CREATING FILE IN STORAGE*****");
    StorageReference storageRef = FirebaseStorage.instance
        .ref()
        .child('Songs/${state.user.username}Songs/$fileName');
    print("*****PUT FILE IN STORAGE*****");
    StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$_fileType/$_extension',
      ),
    );
    print("*****PROCESS COMPLETED*****");
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    storageRef.getDownloadURL().then((fileURL) async {
      print("*****UPDATE URL ON DOC*****");
      await _songService.updateSongURL(fileURL, state.songCopy);
      //print("songURL: " + state.songCopy.songURL);
    });
  }

  Future add() async {
    print("GOT HERE0");
    // fails return nothing
    // documentId comes from this call and saved
    try {
      print("GOT HERE1");
      if (state.audio == null) {
        MyDialog.info(
          context: state.context,
          title: 'No Song Chosen',
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

        try {
          print("POSSIBLE SAVE ERROR");
          state.formKey.currentState.save();
        } catch (e) {
          print("***************************");
          print("***************************");
          print("SAVE ERROR: " + e.toString());
          print("***************************");
          print("***************************");
        }

        print("GOT HERE3");
        state.songCopy.createdBy = state.user.email;
        print("GOT HERE4");
        state.songCopy.lastUpdatedAt = DateTime.now();
        print("GOT HERE5");
        // check firebase addbook successful or not
        try {
          print("GOT HERE6");
          if (state.song == null) {
            // addButton to add song if empty
            print("*****READY TO ADD SONG*****");
            state.songCopy.songId = await _songService.addSong(state.songCopy);
          } else {
            // from homepage to edit a song
            print("GOT HERE7");
            await _songService.updateSong(state.songCopy);
          }

          // pass a value back to caller, which is 2nd argument
          // song just stored in firestore
          // using 2nd arg, caller in homepage addbutton could receive return val
          Navigator.pop(state.context, state.songCopy);
        } catch (e) {
          // if any error occur in firestore, than give null val
          // b in homepage add is null, it wasnt successfully store
          MyDialog.info(
            context: state.context,
            title: 'Firestore Save Error',
            message: 'Firestore is unavailable now. Add Song doc Failed.',
            action: () {
              Navigator.pop(state.context);
              // b null, storing failed
              Navigator.pop(state.context, null);
            },
          );
        }
        print("READY TO UPLOAD SONG");
        await uploadSong();
      }
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Firestore Save Error',
        message: 'Firestore is unavailable now. Upload Song Failed.',
        action: () {
          Navigator.pop(state.context);
          // b null, storing failed
          Navigator.pop(state.context, null);
        },
      );
    }
  }
}
