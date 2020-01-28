import 'dart:async';
import 'package:PawPrint/model/user.dart';
import 'package:PawPrint/view/routingmappage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutingMapPageController{
  RoutingMapPageState state;
  RoutingMapPageController(this.state);
  GoogleMapController maoController;
  List<String>documentList = [];
  void showPetSitters() {
    if(state.documentList!=null){
      print(state.documentList);
      documentList.clear();
    }
  petSitters().whenComplete(updateState);
}
  Future<Null> petSitters()async{
  //Retrieve pet sitters email from providerlist
    QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILELIST_COLLECTION)
      .getDocuments();
        if(querySnapshot==null || querySnapshot.documents.length == 0){
          print('no docID found');
        }
    for(DocumentSnapshot doc in querySnapshot.documents){
      documentList.add(doc.documentID);  
    }
  }
void updateState(){
  if(state.documentList!=null){
    state.documentList.clear();
  }
  state.documentList = <String>[]..addAll(documentList) ;
}
  void petSitterTapped() {
    print('petSitterTapped clicked');
  }
}
