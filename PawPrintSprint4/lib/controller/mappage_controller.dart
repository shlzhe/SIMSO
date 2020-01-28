import 'dart:async';
import 'package:PawPrint/model/user.dart';
import 'package:PawPrint/view/mappage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPageController{
  MapPageState state;
  MapPageController(this.state);
  GoogleMapController maoController;

  Future<void> homeLoc() async {
   print('homeLoc clicked');
   //get home user location based on signed up home address
   print(state.user.street);
   print(state.user.state);

    //Get current user location
   Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   print(position.latitude);  //include lat and long
   print(position.longitude); 
   

  }
  List<String>documentList = [];
    void showPetSitters() {
      if(state.documentList!=null){
        print(state.documentList);
        documentList.clear();
      }
      petSitters().whenComplete(updateState);
  }

  Future<Null> petSitters() async {
      //Retrieve pet sitters email from providerlist
      QuerySnapshot querySnapshot = await Firestore.instance.collection(User.PROFILELIST_COLLECTION)
        .getDocuments();
          if(querySnapshot==null || querySnapshot.documents.length == 0){
            print('no docID found');
          }
            for(DocumentSnapshot doc in querySnapshot.documents){
          documentList.add(doc.documentID);  
    }
    state.stateChanged((){});
  }
  void updateState(){
  if(state.documentList!=null){
    state.documentList.clear();
  }
  state.documentList = <String>[]..addAll(documentList) ;
  for (var i in state.providerList){
      if (i.lati != null){
      state.markers.add(Marker(
      markerId: MarkerId(i.displayName),
      position: LatLng(double.parse(i.lati), double.parse(i.longti)),
      infoWindow: InfoWindow(title: i.displayName),
      icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
      ),
    ));}
    }
  }
}