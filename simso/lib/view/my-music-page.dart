import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simso/model/services/isong-service.dart';
import 'package:simso/model/services/song-service.dart';
import '../model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import '../controller/my-music-controller.dart';
import '../service-locator.dart';
import 'design-constants.dart';
import 'dart:async';
import '../model/entities/globals.dart' as globals;

class MyMusic extends StatefulWidget {
  final UserModel user;
  final List<SongModel> songlist;

  MyMusic(this.user, this.songlist);
  @override
  State<StatefulWidget> createState() {
    return MyMusicState(user, songlist);
  }
}

class MyMusicState extends State<MyMusic> {
  //final navigatorKey = GlobalKey<NavigatorState>();
  MyMusicController controller;
  BuildContext context;
  UserModel user;
  SongModel song;
  SongModel songCopy;
  List<SongModel> songlist;
  List<int> deleteIndices;
  int currentScreenIndex = 0;
  int songCount = songNum;
  ISongService _songService = locator<ISongService>();

  MyMusicState(this.user, this.songlist) {
    controller = MyMusicController(this);
    if (song == null) {
      songCopy = SongModel.empty();
    } else {
      songCopy = SongModel.clone(song);
    }
  }

  void stateChanged(Function fn) {
    setState(fn);
  }

  Container buildUserSongs() {
    if (_songService.getSongList(user.email) == null) {
      return Container();
    } else {
      return Container(
        child: FutureBuilder<List<SongModel>>(
          future: _songService.getSongList(user.email),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else
              return GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
//                    padding: const EdgeInsets.all(0.5),
                  mainAxisSpacing: 1.5,
                  crossAxisSpacing: 1.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data.map((SongModel songPost) {
                    return GridTile(child: ImageTile(songPost));
                  }).toList());
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    globals.context = context;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
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
              'Your Music',
            ),
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox(
                            width: 200.0,
                            height: 220.0,
                            child: user.profilePic != null &&
                                    user.profilePic.trim().isNotEmpty
                                ? Image.network(
                                    user.profilePic,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    DesignConstants.profile,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   child: GridView.count(
              //     primary: false,
              //     crossAxisCount: 3,
              //     childAspectRatio: 1.0,
              //     mainAxisSpacing: 1.5,
              //     crossAxisSpacing: 1.5,
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     children: <Widget>[
              //       songCopy == null
              //           ? Container()
              //           : Card(
              //               color: Colors.black,
              //               child: CachedNetworkImage(
              //                 imageUrl: songCopy.artWork,
              //                 placeholder: (context, url) =>
              //                     CircularProgressIndicator(),
              //                 errorWidget: (context, url, error) =>
              //                     Text("NO SONGS"),
              //               ),
              //             )
              //     ],
              //   ),
              // ),
              Divider(),
              buildUserSongs(),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  final SongModel songPost;

  ImageTile(this.songPost);

  clickedImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                backgroundColor: Colors.black,
                scaffoldBackgroundColor: Colors.black,
                primaryTextTheme:
                    Typography(platform: TargetPlatform.iOS).white,
                textTheme: Typography(platform: TargetPlatform.iOS).white,
                fontFamily: 'Quantum',
              ),
              home: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Text(
                    'Song',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                body: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(1.0) ,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 6.0,
                              //spreadRadius: 0.0,
                              //offset: Offset(.1, 3),
                            )
                          ],
                        ),
                        child: Card(
                          child: CachedNetworkImage(
                            imageUrl: songPost.artWork,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline, size: 250),
                            height: 300,
                            width: 300,
                          ),
                          elevation: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 30, left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${songPost.title}',
                              style: TextStyle(
                                fontSize: 30,
                                //fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 50),
                      child: Row(
                        children: <Widget>[
                          // Container(
                          //   padding: EdgeInsets.only(left: 55, top: 398),
                          //     child: Wrap(
                          //       children: <Widget>[
                          Expanded(
                            child: Text(
                              '${songPost.artist}',
                              style: TextStyle(
                                color: Colors.grey[350],
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    songPost.featArtist == null || songPost.featArtist.isEmpty
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(top: 10, left: 50),
                            child: Row(
                              children: <Widget>[
                                // padding: EdgeInsets.only(left: 55, top: 411),
                                Expanded(
                                  child: Text(
                                    ('ft. ${songPost.featArtist}'
                                        .toString()
                                        .replaceAll('[', '')
                                        .replaceAll(']', '')),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[350],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 50),
                      child: Row(
                        children: <Widget>[
                          // Container(
                          //   padding: EdgeInsets.only(left: 55, top: 398),
                          //     child: Wrap(
                          //       children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                '${songPost.genre}  ',
                                style: TextStyle(
                                  color: Colors.grey[350],
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                '${songPost.pubyear}',
                                style: TextStyle(
                                  color: Colors.grey[350],
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => clickedImage(context),
      child: Image.network(songPost.artWork, fit: BoxFit.cover),
    );
  }
}

// ListView.builder(
//   itemCount: songlist.length,
//   itemBuilder: (BuildContext context, int index) {
//     return Container(
//       color: deleteIndices != null && deleteIndices.contains(index)
//           ? Colors.cyan[200]
//           : Colors.black,
//       child: ListTile(
//           leading: FittedBox(
//             child: Card(
//               elevation: 20,
//               child: CachedNetworkImage(
//                 imageUrl: songlist[index].artWork,
//                 placeholder: (context, url) =>
//                     CircularProgressIndicator(),
//                 errorWidget: (context, url, error) =>
//                     Icon(Icons.error_outline),
//               ),
//             ),
//           ),
//           title: Text(songlist[index].title),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 songlist[index].artist,
//                 style: TextStyle(
//                   color: Colors.grey[300],
//                   fontSize: 10,
//                 ),
//               ),
//               songlist[index].featArtist == null ||
//                       songlist[index].featArtist.isEmpty
//                   ? Container()
//                   : Text(
//                       'feat. ' +
//                           songlist[index]
//                               .featArtist
//                               .toString()
//                               .replaceAll('[', ' ')
//                               .replaceAll(']', ' '),
//                       style: TextStyle(
//                         color: Colors.grey[300],
//                         fontSize: 9,
//                       ),
//                     ),
//             ],
//           ),
//           // need func def no func call
//           // onTap: controller.onTap(index) wrong
//           onTap: () {}, //=> controller.onTap(index),
//           onLongPress: () {} //=> controller.longPress(index),
//           ),
//     );
//   },
// ),

// class ImageTile extends StatelessWidget {
//   final SongModel songPost;

//   ImageTile(this.songPost);

//   clickedImage(BuildContext context) {
//     Navigator.of(context)
//         .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
//       return Center(
//         child: Scaffold(
//             appBar: AppBar(
//               title: Text('Photo',
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//               backgroundColor: Colors.white,
//             ),
//             body: ListView(
//               children: <Widget>[
//                 Container(
//                   child: songPost,
//                 ),
//               ],
//             )),
//       );
//     }));
//   }

//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () => clickedImage(context),
//         child: Image.network(songPost.artWork, fit: BoxFit.cover));
//   }
// }
