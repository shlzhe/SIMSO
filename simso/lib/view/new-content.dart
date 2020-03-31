import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/new-content-page-controller.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/design-constants.dart';

class NewContentPage extends StatefulWidget{
  final UserModel user;
  NewContentPage(this.user);
  @override
  State<StatefulWidget> createState() {
    return NewContentPageState(user);
      }
    
    }
    
    class NewContentPageState extends State<NewContentPage> {
      UserModel user;
      NewContentPageController controller;
      BuildContext context;
      bool meme = false;
      bool music = false;
      bool snapshots = false;
      bool thoughts = true;
      bool friends = false;
      List<Thought> publicThoughtsList =[];
      void stateChanged(Function f){
        setState(f);
      }
      NewContentPageState(this.user){
        controller = NewContentPageController(this);
        controller.thoughts();
      }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(!thoughts && !meme && !snapshots && !music ? 'New Content': 
          thoughts? 'Thoughts' : (meme ? 'Memes':(snapshots ? 'SnapShots':'Music')), style: TextStyle(color: DesignConstants.yellow),),
        backgroundColor: DesignConstants.blue,
      ),
      body: thoughts ? ListView.builder(
                  itemCount: publicThoughtsList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  //padding: EdgeInsets.all(15.0),
                  //color: Colors.grey[200],
                  padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: DesignConstants.blue,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    title: Text(
                      publicThoughtsList.elementAt(index).email + ' '+ publicThoughtsList.elementAt(index).timestamp.toLocal().toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(publicThoughtsList.elementAt(index).text),
                      ],
                    ),
                  ),
                ),
              );
                  },
                  )
            :
            (
              meme ? ListView.builder(
                  itemCount: 0,
                  itemBuilder: (BuildContext context, int index){return Container(
                    child: Text('Memes'),
                  );},
                  )
            : snapshots ? ListView.builder(
                  itemCount: 0,
                  itemBuilder: (BuildContext context, int index){return Container(
                    child: Text('SnapShots'),
                  );},
                  )
            : ListView.builder(
                  itemCount: 0,
                  itemBuilder: (BuildContext context, int index){return Container(
                    child: Text('Music'),
                  );},
                  )
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          RaisedButton(
            child: Text('Thoughts', style: TextStyle(color: DesignConstants.yellow),),
            onPressed: controller.thoughts,
            color: thoughts ? DesignConstants.blueLight : DesignConstants.blue,
            ),
          RaisedButton(
            child: Text('Memes', style: TextStyle(color: DesignConstants.yellow),),
            onPressed: controller.meme,
            color: meme ? DesignConstants.blueLight : DesignConstants.blue,
            ),
            RaisedButton(
            child: Text('SnapShots', style: TextStyle(color: DesignConstants.yellow),),
            onPressed: controller.snapshots,
            color: snapshots ? DesignConstants.blueLight : DesignConstants.blue,
            ),
            RaisedButton(
            child: Text('Music', style: TextStyle(color: DesignConstants.yellow),),
            onPressed: controller.music,
            color: music ? DesignConstants.blueLight : DesignConstants.blue,
            ),
        ],),
      ),
    );
  }
}
