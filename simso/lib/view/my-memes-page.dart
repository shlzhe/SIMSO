import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/entities/user-model.dart';
import '../model/entities/meme-model.dart';
import '../view/design-constants.dart';
import '../controller/my-memes-controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/entities/globals.dart' as globals;

class MyMemesPage extends StatefulWidget {
  final UserModel user;
  final List<Meme> myMemesList;

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
    globals.context = context;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: controller.addMeme,
          backgroundColor: DesignConstants.blue
          ),
        appBar: AppBar(
          title: Text(
            'My Memes',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 30.0,
                color: DesignConstants.yellow),
          ),
          backgroundColor: DesignConstants.blue,
        ),
        //drawer: MyDrawer(context, user),
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
                          title:Text(myMemesList[index].ownerName),
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
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );
}
