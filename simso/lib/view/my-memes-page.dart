import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';
import '../model/entities/user-model.dart';
import '../model/entities/meme-model.dart';
import '../view/design-constants.dart';
import '../view/navigation-drawer.dart';
import '../controller/my-memes-controller.dart';
import '../controller/my-thoughts-controller.dart' as addthought;
import 'package:cached_network_image/cached_network_image.dart';

class MyMemesPage extends StatefulWidget {
  final UserModel user;
  List<Meme> myMemesList;

  MyMemesPage(this.user, this.myMemesList);

  @override
  State<StatefulWidget> createState() {
    return MyMemesPageState(user, myMemesList);
  }
}

class MyMemesPageState extends State<MyMemesPage> {
  BuildContext context;
  MyMemesController controller;

  UserModel user;
  List<Meme> myMemesList;

  //bool entry = false; //keep, there was something I liked about this snippet of code from Hiep

  var formKey = GlobalKey<FormState>();

  MyMemesPageState(this.user, this.myMemesList) {
    controller = MyMemesController(this);
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text("Add Memes"),
          onPressed: controller.addMeme,
          ),
        appBar: AppBar(
          title: Text(
            'Memes Page',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 30.0,
                color: DesignConstants.yellow),
          ),
          backgroundColor: DesignConstants.blue,
        ),
        drawer: MyDrawer(context, user),
        body: ListView.builder(
            itemCount: myMemesList == null ? 0 : myMemesList.length,
            itemBuilder: (BuildContext context, int index) {
              if (myMemesList != null) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                myMemesList[index].ownerPic),
                            backgroundColor: Colors.grey,
                          ),
                          title: GestureDetector(
                            child: Text(myMemesList[index].ownerName),
                            onTap: () =>
                                controller.onTapProfile(myMemesList, index),
                          ),
                          subtitle: Text(DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
                              .format(myMemesList[index].timestamp)),
                          trailing: GestureDetector(
                            child: const Icon(Icons.edit),
                            onTap: () => controller.onTapMeme(
                                myMemesList, index),
                          )
                          ),
                        CachedNetworkImage(
                        imageUrl: myMemesList[index].imgUrl,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      )
                    ],
                  ),
                );
              } else
                return null;
            }));

    // Container(
    //   color: DesignConstants.blueGreyish,
    //   child: ListView.builder(
    //     itemCount: mySnapshotsList == null ? 0 : mySnapshotsList.length,
    //     itemBuilder: (BuildContext context, int index) {
    // return Container(
    //   padding: EdgeInsets.all(15.0),
    //   child: Container(
    //     //padding: EdgeInsets.all(15.0),
    //     //color: Colors.grey[200],
    //     padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
    //     decoration: BoxDecoration(
    //       color: const Color(0xFFFFFFFF),
    //       border: Border.all(
    //         color: DesignConstants.blue,
    //         width: 4,
    //       ),
    //       borderRadius: BorderRadius.circular(30),
    //     ),
    //     child: ListTile(
    //       title: Text(DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
    //           .format(mySnapshotsList[index].timestamp)),
    //       subtitle: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           CachedNetworkImage(
    //             imageUrl: mySnapshotsList[index].imgUrl,
    //             placeholder: (context, url) =>
    //                 CircularProgressIndicator(),
    //             errorWidget: (context, url, error) =>
    //                 Icon(Icons.error_outline),
    //           ),
    //         ],
    //       ),
    //       onTap: () =>
    //           controller.onTapSnapshot(mySnapshotsList, index),
    //     ),
    //   ),
    // );
    //     },
    //   ),
    // )
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );
}
