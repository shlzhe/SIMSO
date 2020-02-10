import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import '../model/user.dart';
//import '../model/song.dart';
import '../controller/add-music-controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddMusic extends StatefulWidget {
  // changes should be done within state object, these should be unchangeable
  // final User user;
  // final Song song;

  // bookpage constructor to store user and book info pass
  AddMusic(/*this.user, this.song*/);

  @override
  State<StatefulWidget> createState() {
    // state we need to pass these info as well
    return AddMusicState(/*this.user, this.song*/);
  }
}

class AddMusicState extends State<AddMusic> {
  // book and user info received
  //User user;
  //Song song;
  //Song songCopy;
  AddMusicController controller;
  var formKey = GlobalKey<FormState>();
  String audio;
  dynamic uploadedFileURL;
  bool songLoaded = false;
  bool sharing = false;
  bool clicked = false;
  bool imageGOT = false;
  var textColor = Colors.black;

  // controller cr8ed inside constructor
  AddMusicState(/*this.user, this.song*/) {
    // we pass the current state obj
    controller = AddMusicController(this);
    // if (song == null) {
    //   // addButton
    //   songCopy = Song.empty();
    // } else {
    //   // this is only copying addr
    //   // but cuz of sharedby we need actual copy
    //   songCopy = Song.clone(song); //clone
    // }
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
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          primaryTextTheme: Typography(platform: TargetPlatform.iOS).white,
          textTheme: Typography(platform: TargetPlatform.iOS).white,
          fontFamily: 'Quantum',
        ),
        home: Scaffold(
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
            backgroundColor: Colors.black,
            title: Text(
              'Add Song',
            ),
          ),
          body: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                ),
                //songCopy.artWork == null ||
                //      songCopy.artWork.isEmpty ||
                imageGOT == false
                    ? Image.asset(
                        "assets/images/PlaylistNezuko_anime_design.png",
                        width: 300,
                        height: 300,
                      )
                    : CachedNetworkImage(
                        //   imageUrl: songCopy.artWork,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline, size: 250),
                        height: 250,
                        width: 250,
                      ),
                songLoaded == false
                    ? ButtonTheme(
                        minWidth: 500,
                        height: 60,
                        buttonColor: Colors.black,
                        child: RaisedButton(
                          child: Text(
                            'Choose Song',
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
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
                        //     songCopy.artWork = null;
                      } else {
                        imageGOT = true;
                        //       songCopy.artWork = text;
                      }
                    });
                  },
                  //    initialValue: songCopy.artWork,
                  decoration: InputDecoration(
                    labelText: 'Artwork',
                  ),
                  style: TextStyle(
                    color: textColor,
                  ),
                  autocorrect: false,
                  validator: controller.validateArtworkUrl,
                  onSaved: controller.saveArtworkUrl,
                ),
                TextFormField(
                  //    initialValue: songCopy.title,
                  decoration: InputDecoration(
                    labelText: 'Song Title',
                  ),
                  style: TextStyle(
                    color: textColor,
                  ),
                  autocorrect: false,
                  validator: controller.validateTitle,
                  onSaved: controller.saveTitle,
                ),
                TextFormField(
                  //     initialValue: songCopy.artist,
                  decoration: InputDecoration(
                    labelText: 'Song Artist',
                  ),
                  style: TextStyle(
                    color: textColor,
                  ),
                  autocorrect: false,
                  validator: controller.validateArtist,
                  onSaved: controller.saveArtist,
                ),
                TextFormField(
                  //        initialValue: songCopy.featArtist.join(',').toString(),
                  decoration: InputDecoration(
                    labelText: 'Song featuring Artist (seperate with comma)',
                  ),
                  style: TextStyle(
                    color: textColor,
                  ),
                  autocorrect: false,
                  validator: controller.validateFeatArtist,
                  onSaved: controller.saveFeatArtist,
                ),
                TextFormField(
                  //        initialValue: songCopy.genre,
                  decoration: InputDecoration(
                    labelText: 'Song Genre',
                  ),
                  style: TextStyle(
                    color: textColor,
                  ),
                  autocorrect: false,
                  validator: controller.validateGenre,
                  onSaved: controller.saveGenre,
                ),
                TextFormField(
                  //      initialValue: '${songCopy.pubyear}',
                  decoration: InputDecoration(
                    labelText: 'Publication Year',
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
                  //       initialValue: songCopy.sharedWith.join(',').toString(),
                  decoration: InputDecoration(
                    labelText: 'Shared with (comma seperated email list)',
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
                            labelText: 'Review',
                            hintText:
                                'Let ur friend knw they should listen to this now!'),
                        autocorrect: false,
                        style: TextStyle(
                          color: textColor,
                        ),
                        //        initialValue: songCopy.review,
                        validator: controller.validateReview,
                        onSaved: controller.saveReview,
                      )
                    : Container(),
                Text(
                  'CreatedBy: ' /*+ songCopy.createdBy*/,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Last Updated At: ' /*+ songCopy.lastUpdatedAt.toString()*/,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  'DocumentID: ' /*+ songCopy.songId.toString()*/,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                RaisedButton(
                  child: Text('Add'),
                  onPressed: controller.add,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
