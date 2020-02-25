import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/entities/user-model.dart';
import '../model/entities/song-model.dart';
import '../controller/add-music-controller.dart';
import 'package:simso/model/services/isong-service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../service-locator.dart';
import 'package:simso/view/design-constants.dart';

class AddMusic extends StatefulWidget {
  // changes should be done within state object, these should be unchangeable
  final UserModel user;
  final SongModel song;

  // bookpage constructor to store user and book info pass
  AddMusic(
    this.user,
    this.song,
  );

  @override
  State<StatefulWidget> createState() {
    // state we need to pass these info as well
    return AddMusicState(
      user,
      song,
    );
  }
}

class AddMusicState extends State<AddMusic> {
  // book and user info received
  UserModel user;
  SongModel song;
  SongModel songCopy;
  AddMusicController controller;
  var formKey = GlobalKey<FormState>();
  ISongService songService = locator<ISongService>();
  String audio;
  dynamic uploadedFileURL;
  bool songLoaded = false;
  bool sharing = false;
  bool clicked = false;
  bool imageGOT = false;
  var textColor = Colors.white;
  double _sigmaX = 8.0; // from 0-10
  double _sigmaY = 8.0; // from 0-10
  double _opacity = 0.4; // from 0-1.0

  // controller cr8ed inside constructor
  AddMusicState(this.user, this.song) {
    // we pass the current state obj
    controller = AddMusicController(this);
    if (song == null) {
      // addButton
      songCopy = SongModel.empty();
    } else {
      // this is only copying addr
      // but cuz of sharedby we need actual copy
      songCopy = SongModel.clone(song); //clone
    }
  }

  void stateChanged(Function fn) {
    setState(fn);
  }

  // void onClick() {
  //   stateChanged(() {
  //     clicked = true;
  //     controller.chooseSong();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: DesignConstants.blueGreyish,
          scaffoldBackgroundColor: DesignConstants.blueGreyish,
          primaryTextTheme: Typography(platform: TargetPlatform.android).white,
          textTheme: Typography(platform: TargetPlatform.android).white,
          fontFamily: 'Quantum',
        ),
        home: Scaffold(
          //backgroundColor: Colors.black,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: DesignConstants.blue,
            title: Text(
              'Add Song',
            ),
          ),
          body: Stack(
            children: <Widget>[
              songCopy.artWork == null ||
                      songCopy.artWork.isEmpty ||
                      imageGOT == false
                  ? Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/PlaylistNezuko_anime_design.png",
                            //width: 300,
                            //height: 300,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter:
                            ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                        child: Container(
                          color: Colors.black.withOpacity(_opacity),
                        ),
                      ),
                    )
                  : Container(
                      child: CachedNetworkImage(
                        imageUrl: songCopy.artWork,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.7),
                                  BlendMode.darken),
                            ),
                          ),
                        ),
                        // placeholder: (context, url) =>
                        //     CircularProgressIndicator(),
                        // errorWidget: (context, url, error) => Icon(
                        //   Icons.error_outline,
                        //   size: 250,
                        //   color: Colors.black,
                        // ),
                      ),
                    ),
              // Container(
              //     decoration: BoxDecoration(
              //       image: DecorationImage(
              //         image: CachedNetworkImage(

              //     imageUrl: songCopy.artWork,
              //     placeholder: (context, url) =>
              //         CircularProgressIndicator(),
              //     errorWidget: (context, url, error) =>
              //         Icon(Icons.error_outline, size: 250),
              //     height: 250,
              //     width: 250,
              //   ),
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //     child: BackdropFilter(
              //       filter:
              //           ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
              //       child: Container(
              //         color: Colors.white.withOpacity(_opacity),
              //       ),
              //     ),
              //   ),

              Container(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      songLoaded == false
                          ? ButtonTheme(
                              minWidth: 500,
                              height: 60,
                              buttonColor: DesignConstants.blue,
                              child: RaisedButton(
                                child: Text(
                                  'Choose Song',
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: DesignConstants.yellow,
                                  ),
                                ),
                                onPressed: controller.chooseSong,
                              ),
                            )
                          : ButtonTheme(
                              minWidth: 500,
                              height: 60,
                              buttonColor: Colors.black,
                              child: RaisedButton(
                                child: Text(
                                  'Song loaded',
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.greenAccent[200],
                                  ),
                                ),
                                onPressed: null,
                              ),
                            ),
                      TextFormField(
                        onChanged: (text) {
                          stateChanged(() {
                            if (text == null || text.trim().isEmpty) {
                              imageGOT = false;
                              songCopy.artWork = null;
                            } else {
                              imageGOT = true;
                              songCopy.artWork = text;
                            }
                          });
                        },
                        initialValue: songCopy.artWork,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Artwork *',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: TextStyle(
                          color: textColor,
                        ),
                        autocorrect: false,
                        validator: controller.validateArtworkUrl,
                        onSaved: controller.saveArtworkUrl,
                      ),
                      TextFormField(
                        initialValue: songCopy.title,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Song Title *',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: TextStyle(
                          color: textColor,
                        ),
                        autocorrect: false,
                        validator: controller.validateTitle,
                        onSaved: controller.saveTitle,
                      ),
                      TextFormField(
                        initialValue: songCopy.artist,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Song Artist *',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: TextStyle(
                          color: textColor,
                        ),
                        autocorrect: false,
                        validator: controller.validateArtist,
                        onSaved: controller.saveArtist,
                      ),
                      TextFormField(
                        initialValue: songCopy.featArtist.join(',').toString(),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Song featuring Artist (leave empty)',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: TextStyle(
                          color: textColor,
                        ),
                        autocorrect: false,
                        validator: controller.validateFeatArtist,
                        onSaved: controller.saveFeatArtist,
                      ),
                      TextFormField(
                        initialValue: songCopy.genre,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Song Genre (anything for now)',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: TextStyle(
                          color: textColor,
                        ),
                        autocorrect: false,
                        validator: controller.validateGenre,
                        onSaved: controller.saveGenre,
                      ),
                      TextFormField(
                        initialValue: '${songCopy.pubyear}',
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Release Year *',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: TextStyle(
                          color: textColor,
                        ),
                        autocorrect: false,
                        validator: controller.validatePubyear,
                        onSaved: controller.savePubyear,
                      ),
                      TextFormField(
                        // conversion, array join with comma
                        // each element in list join wif comma and convert to string data
                        onChanged: (text) {
                          stateChanged(() {
                            if (text == null || text.trim().isEmpty) {
                              sharing = false;
                            } else {
                              sharing = true;
                            }
                          });
                        },
                        initialValue: songCopy.sharedWith.join(',').toString(),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: 'Shared with (leave empty)',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: TextStyle(
                          color: textColor,
                        ),
                        autocorrect: false,
                        validator: controller.validateSharedWith,
                        onSaved: controller.saveSharedWith,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      sharing == true
                          ? TextFormField(
                              maxLines: 5,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: 'Review',
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                hintText:
                                    'Let ur friends knw they should listen to this now!',
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              autocorrect: false,
                              style: TextStyle(
                                color: textColor,
                              ),
                              initialValue: songCopy.review,
                              validator: controller.validateReview,
                              onSaved: controller.saveReview,
                            )
                          : Container(),
                      Text(
                        'CreatedBy: ' + songCopy.createdBy,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Last Updated At: ' + songCopy.lastUpdatedAt.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'DocumentID: ' + songCopy.songId.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 500,
                        height: 60,
                        buttonColor: DesignConstants.blue,
                        child: RaisedButton(
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 40,
                              color: DesignConstants.yellow,
                            ),
                          ),
                          onPressed: controller.add,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
