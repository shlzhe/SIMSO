import 'package:PawPrint/controller/homepage_controller.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/user.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget{

//User object and constructor 
//Since user is transfer from FrontPage to HomePage
final List<Pet> petList;
final User user;
//Constructor
HomePage(this.user, this.petList);


  @override
  State<StatefulWidget> createState() {
    
    return HomePageState(user, petList);
  }

}

class HomePageState extends State<HomePage>{
  //User object 
  bool sharedWithMe=false;
  User user;
  List<Pet> petList;
  HomePageController controller;
  BuildContext context;
  List<int> deleteIndices;   //fore delete books

  HomePageState(this.user, this.petList){
    controller = HomePageController(this);
  }

  void stateChanged(Function fn){
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (user.level == 'provider' || user.level=='admin'){
      sharedWithMe = true;
    }
    this.context = context;
    return WillPopScope(   //Disable return button on Android
          onWillPop: (){return Future.value(false);},
          child: Scaffold(
        appBar: AppBar(
          title: Text('HomePage',style: TextStyle(fontSize: 45,fontFamily: 'Modak'),),
          backgroundColor: Colors.green,
          actions: deleteIndices == null ? null :<Widget>[
            FlatButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: controller.deleteButton,
            )
          ],

        ),
       
        //Create DRAWER to replace return button on HOME PAGE
        drawer: Drawer(
          child: ListView(   
            children: <Widget>[
               UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: (user.profilePic == '' || user.profilePic == null || user.profilePic.isEmpty) ? Text('No Image') : Text(''),
                  backgroundImage: (user.profilePic == '' || user.profilePic == null || user.profilePic.isEmpty) ? null : NetworkImage(user.profilePic),
                ),
                accountName: Text(user.displayName,style: TextStyle(fontSize: 15,fontFamily: 'Modak'),),
                accountEmail: Text(user.email,style: TextStyle(fontSize: 15,fontFamily: 'Modak'),),
                decoration: BoxDecoration(color: Colors.green),
              ),
              Text('     User status: ${user.level}'),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Profile'),
                onTap: controller.profileButton,
              ),
              ListTile(
                leading: Icon(Icons.pets),
                title: Text('Pet Profile'),
                onTap: controller.petProfileButton,
              ),
              sharedWithMe != true ? Text('',style:  TextStyle(fontSize: 0),) :
              ListTile(
                leading: Icon(Icons.pets),
                title: Text('Shared Pet'),
                onTap: controller.petShared,
              ),
              (user.level!='provider') ? Text('', style: TextStyle(fontSize: 0)):
              ListTile(
                leading: Icon(Icons.pets),
                title: Text('Ordered Service'),
                onTap: controller.orderedService,
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Find a Pet sitter near me'),
                onTap: controller.mapButton,

              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: controller.signOut,
              ),    //Special Widget for Drawer

            ],
          ),
        ),
        
        //body: Text('# of books = ${booklist.length}     ${user.email}   ${user.displayName}' ),
        body: Column(
          children: <Widget>[
          //IMAGE BUTTONS
          //BOOK A NEW SERVICE BUTTON
          Container(
            padding: EdgeInsets.all(5),
            child: RaisedButton(
            child:  Image.network('https://firebasestorage.googleapis.com/v0/b/pawprintmatermproj.appspot.com/o/PawPrintImages%2Fbooknewervice.jpg?alt=media&token=2e9df86f-89b5-442d-ab2d-adec5044145a'),
            elevation: 0.0,
            splashColor: Colors.white,
            onPressed: controller.bookService,
        ),
          ),
          //BECOME A PET SITTER BUTTON
        user.level == 'user' || user.level =='' ?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child:  Image.network('https://firebasestorage.googleapis.com/v0/b/pawprintmatermproj.appspot.com/o/PawPrintImages%2Fbecome-a-sitter.jpg?alt=media&token=27716ceb-d9e3-47e8-83a4-3d523061a2b3'),
            elevation: 0.0,
            splashColor: Colors.white,
            onPressed: controller.becomeAPetSitter,
          ),
        )
       : Text('',style:  TextStyle(fontSize: 0),),
          



          ],
        )
        
      
      ),
    );
  }

}