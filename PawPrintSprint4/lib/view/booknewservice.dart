import 'package:PawPrint/controller/booknewservice_controller.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class BookNewService extends StatefulWidget{
  final List<Pet> petList;
  final User user;
  final List<User> userList;
  BookNewService(this.user, this.userList, this.petList);
  @override
  State<StatefulWidget> createState() {
    return BookNewServiceState(user, userList, petList);
  }
}
  class BookNewServiceState extends State<BookNewService>{
    User user;
    List<Pet> petList;
    List<User> userList;
    BuildContext context;
    BookNewServiceController controller;
    BookNewServiceState(this.user, this.userList, this.petList){
      controller = BookNewServiceController(this);
    }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
     appBar: AppBar(
        title: Text('Select a provider',style: TextStyle(fontSize: 25,fontFamily: 'Modak'),),   //appBar title and font
        backgroundColor: Colors.green,   //appBar backgroud color
      ),
      body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              padding: EdgeInsets.all(5.0),
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: userList[index].profilePic == null? '':userList[index].profilePic,
                  placeholder: (context, url)=>CircularProgressIndicator(),
                  errorWidget: (context, url, error)=>Icon(Icons.error_outline),
                ),
                title: Text('Name: '+userList[index].displayName,),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('City: '+userList[index].city),
                    Text('Email: '+userList[index].email),
                    Text('Boarding: '+userList[index].boardingRate.toString()),
                    Text('Walking: '+userList[index].walkingRate.toString()),
                    Text('Day Care: '+userList[index].dayCare.toString()),
                    Text('DropIn Visits: '+userList[index].dropInVisit.toString()),
                    Text('House Sitting: '+userList[index].houseSitting.toString()),
                  ],
                ),
                onTap: ()=>controller.onTap(index),
              ),
            );
          },
        ),

    );
  }
    
  }