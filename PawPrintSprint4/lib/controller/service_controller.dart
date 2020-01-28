import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/model/saveservice.dart';
import 'package:PawPrint/model/user.dart';
import 'package:PawPrint/view/routingmappage.dart';
import 'package:PawPrint/view/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceController{
  ServiceState state;
  ServiceController(this.state);      
  DateTime startdate = DateTime.now();
  TimeOfDay starttime = TimeOfDay.now();
  DateTime enddate = DateTime.now();
  TimeOfDay endtime = TimeOfDay.now();
  OrderService orderedService;
  String selectedPetSitter;  //hold value of selected petsitter's email
  String latiPetSitter;
  String longtiPetSitter;
  String latiCustomer;
  String longtiCustomer;
  List <User> petSitter = [];
  List<User> customer = [];
  void startDate(){
    timeStart(state.context).whenComplete(updateStart);
    dateStart(state.context);
  }
  void updateStart(){
    state.stateChanged((){
      state.startDate = startdate;
      state.startTime = starttime;
      state.days= state.startDate.difference(state.endDate).inDays.abs()+1;
      state.price = state.service*(state.days+1);
    });
  }
  Future<Null> dateStart(BuildContext context) async{
        DateTime picked = await showDatePicker(
          context: context,
          initialDate: startdate,
          firstDate: DateTime(2019),
          lastDate: DateTime(2021),
        );
        if (picked != null && picked != startdate){
            startdate = picked;
        }
      }
      Future<Null> timeStart(BuildContext context) async{
        TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: starttime,
        );
        if (picked != null && picked != starttime){
            starttime = picked;
        }
      }
  void endDate(){
    timeEnd(state.context).whenComplete(updateEnd);
    dateEnd(state.context);
  }
  void updateEnd(){
    state.stateChanged((){
      state.endDate = enddate;
      state.endTime = endtime;
      state.days= state.startDate.difference(state.endDate).inDays.abs()+1;
      state.price = state.service*(state.days+1);
    });
  }
  Future<Null> dateEnd(BuildContext context) async{
        DateTime picked = await showDatePicker(
          context: context,
          initialDate: enddate,
          firstDate: DateTime(2019),
          lastDate: DateTime(2021),
        );
        if (picked != null && picked != enddate){
            enddate = picked;
        }
      }
      Future<Null> timeEnd(BuildContext context) async{
        TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: endtime,
        );
        if (picked != null && picked != endtime){
            endtime = picked;
        }
      }

  void selection(String value) {
    state.stateChanged((){
      state.selection=value;
      if (value=='Boarding') state.service = state.provider.boardingRate;
      else if (value=='Walking') state.service = state.provider.walkingRate;
      else if (value=='DayCare') state.service = state.provider.dayCare;
      else if (value=='DropIn') state.service = state.provider.dropInVisit;
      else if (value=='HouseSitting') state.service = state.provider.houseSitting;
      state.price = state.service*(state.days+1);
    });
  }

  void calculatePrice() {
    state.stateChanged((){
      state.price = state.service*(state.days+1);
    });
  }
   Future scheduleService() async {
    for (var i in state.petListcopy){
      i.sharedWith= <dynamic>[]..add(state.provider.email);
      MyFirebase.addPet(i);

    }
    var dateTime = DateTime.now().toString();
    orderedService = OrderService.setOrder(
      state.price, 
      state.selection, 
      state.provider.email, 
      state.user.email, 
      state.user.numOfPets,
      state.user.street + ',' + state.user.city + ',' + state.user.state + ',' + state.user.zip.toString(),
      dateTime,     
      );

    // might need to move line 116 to dialog box.
    MyFirebase.createOrder(orderedService);
    print('scheduleService called');
    //-----------
    print('customer: ${state.user.email}');
    print('petsitter: ${state.provider.email}');
    selectedPetSitter = state.provider.email;

    
    //Retrieve document ID from userprofile
    QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILE_COLLECTION)
       .where('email', isEqualTo: state.user.email)
       .getDocuments();
         if(querySnapshot==null || querySnapshot.documents.length == 0){
           print('no docID found');
         }
    //Create new field named petsitter that hold selected petsitter's email
      for(DocumentSnapshot doc in querySnapshot.documents){    
              //Deserialize to get all fields in selected petsitter
               customer.add(User.deserialize(doc.data));
      
              //Create petsitter field to petsitter provider
              Firestore.instance.collection('userprofile')
                      .document('${doc.documentID}').updateData({
                      'petsitter': '$selectedPetSitter',
                      });    
          }

     //Update customer lati and longti in user interface for schedule service button
     for(var item in customer){
       state.stateChanged((){
         state.user.lati = item.lati;
         state.user.longti = item.longti;
       });
       
     }
    
    //Retrieve selected petsitter doc ID
     QuerySnapshot querySnapshot2 = await Firestore.instance.collection(User.PROFILE_COLLECTION)
       .where('email', isEqualTo: '$selectedPetSitter' )
       .getDocuments();
         if(querySnapshot==null || querySnapshot.documents.length == 0){
           print('no docID found');
         }
      //Deserialize to get all fields in selected petsitter
      for(DocumentSnapshot doc in querySnapshot2.documents){  
        print('petsitter: ${doc.documentID}');
         petSitter.add(User.deserialize(doc.data));
      }
      
      for(var item in petSitter){
        latiPetSitter = item.lati;
        longtiPetSitter = item.longti;
      }
    //Navigate to routingMapPage
    Navigator.push(state.context, MaterialPageRoute(
      builder: (context) => RoutingMapPage(state.user,selectedPetSitter,latiPetSitter,longtiPetSitter),  
    ));

  }

}