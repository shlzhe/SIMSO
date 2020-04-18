import 'package:flutter/material.dart';
import '../model/entities/user-model.dart';
import '../model/entities/thought-model.dart';
import '../view/design-constants.dart';
import '../controller/search-page-controller.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/design-constants.dart';

class SearchPage extends StatefulWidget {
  final UserModel user;
  

  SearchPage(this.user);

  @override
  State<StatefulWidget> createState() {
    return SearchPageState(user);
  }
}

class SearchPageState extends State<SearchPage> {
  BuildContext context;
  SearchPageController controller;
  List<Thought> thoughtList = [];
  Set<Thought> thoughtSet = {};
  UserModel user;
  String searchTerm;

  var formKey = GlobalKey<FormState>();

  SearchPageState(this.user) {
    controller = SearchPageController(this);
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
            'Search',
            style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 30.0,
                color: DesignConstants.yellow),
          ),
          backgroundColor: DesignConstants.blue,
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextFormField(
                    maxLines: 1,
                    initialValue: '',
                    validator: controller.validateSearchTerms,
                    onTap: controller.search,
                    style: TextStyle(fontSize: 22.0, color: Colors.grey[700]),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Ex. Blue',
                      hintStyle:
                          TextStyle(fontSize: 20.0, color: Colors.grey[400]),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 14.0, bottom: 8.0),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: RaisedButton(
                    child: Text(
                      'Search',
                      style: TextStyle(fontSize: 22.0, color: Colors.grey[900]),
                    ),
                    onPressed: controller.search,
                    padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                  ),
                ),                
              ],
            ),
          ),
        ));
  }
}