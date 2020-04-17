import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ipicture-service.dart';
import 'package:simso/view/design-constants.dart';
import '../controller/snapshot-page-controller.dart';
import '../model/entities/user-model.dart';
import '../model/entities/image-model.dart';
import '../model/services/ipicture-service.dart';
import '../model/services/picture-service.dart';
import '../service-locator.dart';
import '../model/entities/globals.dart' as globals;

class SnapshotPage extends StatefulWidget {

  final UserModel user;
  final List<ImageModel> imagelist;

  SnapshotPage(this.user, this.imagelist);

  @override
  State<StatefulWidget> createState() {
    return SnapshotPageState(user, imagelist);
  }
}

class SnapshotPageState extends State<SnapshotPage> {

  UserModel user;
  ImageModel image;
  ImageModel imageCopy;
  List<ImageModel> imagelist;
  List<int> deleteIndices;
  int currentScreenIndex = 0;
  int imageCount = imageNum;
  IImageService _imageService = locator<IImageService>();
  SnapshotPageController controller;
  var formKey = GlobalKey<FormState>();
  BuildContext context;

  SnapshotPageState(this.user, this.imagelist) {
    controller = SnapshotPageController(this);
  }

  void stateChanged(Function fn) {
    setState(fn);
  }

  Container buildUserImages() {
    if (_imageService.getImageList(user.email) == null) {
      return Container();
    } else {
      return Container(
        child: FutureBuilder<List<ImageModel>>(
          future: _imageService.getImage(user.email),
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
                  mainAxisSpacing: 1.5,
                  crossAxisSpacing: 1.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data.map((ImageModel imagePost) {
                    return GridTile(child: ImageTile(imagePost));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username + ' Snapshot'),
        backgroundColor: DesignConstants.blue,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Divider(),
          buildUserImages(),
        ],
      ),
    );
  }
}

  buildPost() {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
  }

  class ImageTile extends StatelessWidget {
  final ImageModel imagePost;

  ImageTile(this.imagePost);

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
              home: Scaffold(
                appBar: AppBar(
                  backgroundColor: DesignConstants.blue,
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
                    '${imagePost.lastUpdatedAt}',
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
                        child: CachedNetworkImage(
                          imageUrl: imagePost.imageURL,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error_outline, size: 250),
                          height: 300,
                          width: 300,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${imagePost.summary}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
      child: Image.network(imagePost.imageURL, fit: BoxFit.cover),
    );
  }
}

