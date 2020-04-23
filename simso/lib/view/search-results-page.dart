import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:simso/controller/new-content-page-controller.dart';
import 'package:simso/controller/search-results-page-controller.dart';
import 'package:simso/model/entities/image-model.dart';
import 'package:simso/model/entities/meme-model.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
import 'package:simso/view/design-constants.dart';
import 'package:simso/view/profile-page.dart';


import 'emoji-container.dart';

class SearchResultsPage extends StatefulWidget {
  final UserModel user;
  final List<Thought> thoughtList;
  SearchResultsPage(this.user, this.thoughtList);
  @override
  State<StatefulWidget> createState() {
    return SearchResultsPageState(user, thoughtList);
  }
}

class SearchResultsPageState extends State<SearchResultsPage> {
  UserModel user;
  SearchResultsPageController controller;
  BuildContext context;
  IUserService userService = locator<IUserService>();
  List<Thought> thoughtList;
  bool emptyList = true;

  gotoProfile(String uid) async {
    UserModel visitUser = await userService.readUser(uid);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfilePage(user, visitUser, true)));
  }

  void stateChanged(Function f) {
    setState(f);
  }

  SearchResultsPageState(this.user, this.thoughtList) {
    controller = SearchResultsPageController(this);
    if(this.thoughtList.length > 0)
      emptyList = false;
    else
      emptyList = true;
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Search Results',
          style: TextStyle(color: DesignConstants.yellow),
        ),
        backgroundColor: DesignConstants.blue,
      ),
      body: emptyList 
      ? Container(
        child: Text('No results found',style: TextStyle(fontSize: 24)),
      )
      : ListView.builder(
              itemCount: thoughtList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    //color: Colors.grey[200],
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      border: Border.all(
                        color: DesignConstants.blue,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ListTile(
                      title: FlatButton.icon(
                          onPressed: () {
                            gotoProfile(
                                thoughtList.elementAt(index).uid);
                          },
                          icon: thoughtList
                                      .elementAt(index)
                                      .profilePic !=
                                  ''
                              ? Builder(builder: (BuildContext context) {
                                  try {
                                    return Container(
                                        width: 35,
                                        height: 35,
                                        child: Image.network(thoughtList
                                            .elementAt(index)
                                            .profilePic));
                                  } on PlatformException {
                                    return Icon(Icons.error_outline);
                                  }
                                })
                              : Icon(Icons.error_outline),
                          label: Expanded(
                            child: Text(
                              thoughtList.elementAt(index).email +
                                  ' ' +
                                  thoughtList
                                      .elementAt(index)
                                      .timestamp
                                      .toLocal()
                                      .toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            thoughtList.elementAt(index).text,
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                      trailing: EmojiContainer(
                        this.context,
                        this.user,
                        mediaTypes.thought.index,
                        thoughtList[index].thoughtId,
                        thoughtList[index].uid,
                      ),
                    ),
                  ),
                );
              },
            )

    );
  }
}
