import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/saveservice.dart';
import 'package:PawPrint/model/user.dart';
import 'package:PawPrint/view/booknewservice.dart';
import 'package:PawPrint/view/frontpage.dart';
import 'package:PawPrint/view/homepage.dart';
import 'package:PawPrint/view/mappage.dart';
import 'package:PawPrint/view/mydialog.dart';
import 'package:PawPrint/view/myyesnodialog.dart';
import 'package:PawPrint/view/orderedservice.dart';
import 'package:PawPrint/view/petprofileList.dart';
import 'package:PawPrint/view/profilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class HomePageController{
  HomePageState state;
  HomePageController(this.state);


  void signOut() async{
    //Display confirmation dialog box after user clicking on "Sign Out" button
    showDialog (
      context: state.context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Would you like to sign out?') ,
          actions: <Widget>[
            RaisedButton(
              child: Text('YES',style: TextStyle(color: Colors.white),),
              color: Colors. green,
              onPressed: (){
                //Dialog box pop up to confirm signing out
                MyFirebase.signOut();       
                //Close Drawer, then go back to Front Page
                Navigator.pop(state.context);  //Close Dialog box
                Navigator.pop(state.context);  //Close Drawer
                //Navigator.pop(state.context);  //Close Home Page 
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> FrontPage(),
                ));
              },
            ),
            RaisedButton(
              child: Text('NO',style: TextStyle(color: Colors.white),),
              color: Colors. green,
              onPressed: ()=>Navigator.pop(state.context),  //close dialog box 
            ),
          ],
        );
        
      },
    );
  }

  void deleteButton() async {
    //sort decending order of deleteIndices to avoice shifting of index when delete
    state.deleteIndices.sort((n1,n2){
      if (n1 < n2) return 1;
      else if (n1 == n2) return 0;
      else  return -1;
    });
    //Close draw
    Navigator.pop(state.context);
  }

  Future mapButton() async {
    //UPDATE COORDINATES IN FIRESTORE FIRST BEFORE VIEWING MAP
    //Convert address to coorfinates
       state.user.searchAdd = "${state.user.street}, ${state.user.city}, ${state.user.state}, ${state.user.zip}";
       var address = await Geocoder.local.findAddressesFromQuery(state.user.searchAdd);
       var first = address.first;
       print("${first.featureName}: ${first.coordinates} in frontPage_controller");
    
       state.user.lati = first.coordinates.latitude.toString();
       state.user.longti = first.coordinates.longitude.toString();
       
       //------------------------   
       // Update coordinates in Firestore
       //FIRST, find the docID of the user
       try{
         QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILE_COLLECTION).
         where('email', isEqualTo: state.user.email).getDocuments();
         
         if(querySnapshot==null || querySnapshot.documents.length == 0){
           print('no docID found');
         }
         for(DocumentSnapshot doc in querySnapshot.documents){

        
        print('Selected docID: ${doc.documentID}');
        
        //UPDATE COORDINATES IN FIRESTORE EVEYTIME THE USER LOG IN
        await Firestore.instance.collection('userprofile')
        .document(doc.documentID).updateData({
          'lati': state.user.lati,
          'longti': state.user.longti,
          'street': state.user.street,
          'city': state.user.city,
          'state': state.user.state,
          'zip': state.user.zip,
          });
 
               }
            
       }
       catch(e){
         throw e;}

    //AFTER UPDATE LATI AND LONGTI IN USERPROFILE
    //NOW SET LATI AND LONGTI IN PROVIDERLIST
    //---------------------------------------------
       try{
         QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILELIST_COLLECTION).
         where('email', isEqualTo: state.user.email).getDocuments();
         
         if(querySnapshot==null || querySnapshot.documents.length == 0){
           print('no docID found');
         }
         for(DocumentSnapshot doc in querySnapshot.documents){
        print('Selected provider in providerlist: ${doc.documentID}');
        
        //UPDATE COORDINATES IN FIRESTORE EVEYTIME THE USER LOG IN
        await Firestore.instance.collection('providerlist')
        .document(doc.documentID).updateData({
          'lati': state.user.lati,
          'longti': state.user.longti,
          'street': state.user.street,
          'city': state.user.city,
          'state': state.user.state,
          'zip': state.user.zip,
          });
 
               }
            
       }
       catch(e){
         throw e;}





    //---------------------------------------------
    try{
      userList = await MyFirebase.getUserList();
      print(userList);
    }catch(error){
      userList = <User>[];
      print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    }
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => MapPage(state.user, userList),  
    ));
  }

  void profileButton(){
    print('profileButton clicked');
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) =>ProfilePage(state.user),  
    ));
  }

  List<User> userList;
  Future bookService() async {
    
    try{
      userList = await MyFirebase.getProviderList();
    }catch(error){
      userList = <User>[];
    }
    //Navgator to Book A New Service Page
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => BookNewService(state.user, userList, state.petList),
    ));
  }

  void petProfileButton() {
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) =>PetProfilePage(state.user, state.petList, false),  
    ));
  }

  Future petShared() async {
    List<Pet> sharedList;
    try{
      //provider email.
      sharedList = await MyFirebase.sharedPetList(state.user.email);
    }catch(error){
      sharedList = <Pet>[];
    }
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context)=> PetProfilePage(state.user, sharedList, true)
    ));
  }

  Future orderedService() async {
    List<OrderService> orderList;
    try{
      orderList= await MyFirebase.getOrders(state.user.email);
    }catch(error){
      orderList = <OrderService>[];
    }
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context)=> OrderedService(state.user, orderList),
    ));
  }
  var documentList=[];
  void becomeAPetSitter(){
    documentList.clear();   //avoid duplicate when this function is called multiple times
    print('becomeAPetSitter called');
    MyYesNoDialog.info(
      context: state.context,
      title: 'Change Your User Level',
      message: 'Become a pet sitter now?',
      yes: () async {
       print('Yes clicked');
       //CHANGE LEVEL FIELD IN USERPROFILE TO PROVIDER
          //Retrieve document ID from userprofile
    QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILE_COLLECTION)
       .where('email', isEqualTo: state.user.email)
       .getDocuments();
         if(querySnapshot==null || querySnapshot.documents.length == 0){
           print('no docID found');
         }
           //Update level of current user to provider
           for(DocumentSnapshot doc in querySnapshot.documents){    
              documentList.add(User.deserialize(doc.data));
              //Update level field to provider
              Firestore.instance.collection('userprofile')
                      .document('${doc.documentID}').updateData({
                      'level': "provider",
                      }); 
              //Change state of user on screen
              state.stateChanged((){
              state.user.level = 'provider';
              print(state.user.level);
          });
           
          }
          
        MyDialog.info(
          context: state.context,
          title: 'CONGRATULATION!!!!!',
          message: 'You have become a pet sitter',
          action: (){
              //Exit dialog boxes
            Navigator.pop(state.context);
            Navigator.pop(state.context);

          }
        );
       //ADD ANOTHER DOCUMENT ID IN PROVIDER LIST FOR CURRENT USER 
       MyFirebase.createProviderList(state.user);
      },
      no: (){
        Navigator.pop(state.context);
      },

     


    );

  }
}
