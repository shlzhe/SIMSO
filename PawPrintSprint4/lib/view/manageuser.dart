import 'package:PawPrint/controller/manageuser_controller.dart';
import 'package:PawPrint/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ManageUserPage extends StatefulWidget{
  final List<User> userList;
  ManageUserPage(this.userList);
  @override
  State<StatefulWidget> createState() {
    return ManageUserState(userList);
      }
    
    }
    
    class ManageUserState extends State<ManageUserPage>{
      BuildContext context;
      List<User> userList;
      List<int> deleteIndices;
      bool deleteMode;
      ManageUserController controller;
      ManageUserState(this.userList){
        controller = ManageUserController(this);
      }
      void stateChanged(Function f){
        setState(f);
      }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page',style: TextStyle(fontSize: 30,fontFamily: 'Modak'),),
          backgroundColor: Colors.green,
        actions: 
          deleteMode == true ? <Widget>[
          FlatButton.icon(
            label: Text('Disable'),
            icon: Icon(Icons.delete_forever),
            onPressed: controller.delete,
          )] : null,
      ),
      body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              padding: EdgeInsets.all(5.0),
              color: deleteIndices != null && deleteIndices.contains(index) ?
                  Colors.cyan : Colors.white,
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: userList[index].profilePic==null?'':userList[index].profilePic,
                  placeholder: (context, url)=>CircularProgressIndicator(),
                  errorWidget: (context, url, error)=>Icon(Icons.error_outline),
                ),
                title: Text('Name: '+userList[index].displayName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Email: '+userList[index].email),
                    Text('Level: '+userList[index].level.toString()),
                    Text('Zip: '+userList[index].zip.toString()),
                  ],
                ),
                onTap: ()=>controller.onTap(index),
                onLongPress: ()=>controller.onLongPress(index),
              ),
            );
          },
        ),
    );
  }
}