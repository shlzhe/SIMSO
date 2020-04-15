import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/entities/meme-model.dart';
import '../model/entities/user-model.dart';
import '../view/design-constants.dart';
import '../controller/visit-memes-controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VisitMemesPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel visitUser;
  List<Meme> visitMemesList;

  VisitMemesPage(this.currentUser, this.visitUser, this.visitMemesList);

  @override
  State<StatefulWidget> createState() {
    return VisitMemesPageState(currentUser, visitUser, visitMemesList);
  }
}

class VisitMemesPageState extends State<VisitMemesPage> {
  BuildContext context;
  VisitMemesController controller;
  UserModel currentUser;
  UserModel visitUser;

  List<Meme> visitMemesList;
  var formKey = GlobalKey<FormState>();

  VisitMemesPageState(this.currentUser, this.visitUser, this.visitMemesList) {
    controller = VisitMemesController(this);
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            visitUser.username + "'s Memes",
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 30.0,
                color: DesignConstants.yellow),
          ),
          backgroundColor: DesignConstants.blue,
        ),
        body: ListView.builder(
            itemCount: visitMemesList == null ? 0 : visitMemesList.length,
            itemBuilder: (BuildContext context, int index) {
              if (visitMemesList != null) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                visitMemesList[index].ownerPic),
                            backgroundColor: Colors.grey,
                          ),
                          title: GestureDetector(
                            child: Text(visitMemesList[index].ownerName),
                          ),
                          subtitle: Text(DateFormat("MMM dd-yyyy 'at' HH:mm:ss")
                              .format(visitMemesList[index].timestamp)),
                          ),
                        CachedNetworkImage(
                        imageUrl: visitMemesList[index].imgUrl,
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
}
