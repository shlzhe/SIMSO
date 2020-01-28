

import 'dart:async';
import 'package:PawPrint/controller/mappage_controller.dart';
import 'package:PawPrint/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



class MapPage extends StatefulWidget {
  final List<User> providerList;
  final User user;
//Constructor
  MapPage(this.user, this.providerList);
  @override
  State<StatefulWidget> createState() {
    return MapPageState(user, providerList);
  }
}

class MapPageState extends State<MapPage> {
  List<User> providerList;
  List<Marker> markers;
  static var location = new Location();
  Completer<GoogleMapController> _controller = Completer();

  User user;
  
 
  MapPageController controller;
  BuildContext context;

  List<int> deleteIndices; //fore delete books

  MapPageState(this.user, this.providerList) {
    controller = MapPageController(this);
    Marker home = Marker(
      markerId: MarkerId('Home'),
      position: LatLng(double.parse(user.lati), double.parse(user.longti)),
      infoWindow: InfoWindow(title: 'Home'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen,
      ),
    );
    
    markers=<Marker>[]..add(home);
  }
  
  void stateChanged(Function fn) {
    //setState(fn);
    setState((){
    
    });
   
  }
  
  GoogleMapController mapController;
 
  String searchAdd;

  var formKey = GlobalKey<FormState>();
  
  bool mapToggle = false;
  var currentLocation;
  var petSitters = [];
  
  void initState(){
    print('initState called');
    super.initState();
    Geolocator().getCurrentPosition().then((currLoc){
      setState(() {
        currentLocation = currLoc;
        mapToggle = true;
        populatePetSitters();
      });
    });
  }
  
  populatePetSitters(){
    print('populatePetSitters called');
      petSitters=[];
      Firestore.instance.collection('providerlist')
      .getDocuments().then((docs){
        if(docs.documents.isNotEmpty){
         for(int i= 0; i < docs.documents.length;i++){
              petSitters.add(docs.documents[i].data);
              //print(docs.documents[i].data);
         }
        }
      });
      
      for(int i  = 0; i <petSitters.length;i++){
        print(petSitters[i]);
      }
  }
  
  List<String> documentList = [];

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Home Location'),
        
        backgroundColor:  Colors.green,
      ),
      body: 
         Form(
           key:formKey,
              child: Stack(
                  children: <Widget>[
                    
                      _googleMap(context),
                          ],
                      ),
          
          ),
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(45),
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: controller.showPetSitters,
          tooltip: 'Pet Sitters',
          child: Text('Search'),
        ),

      ),
      
    );
  }
 

  
  Widget _googleMap(BuildContext context) {
    
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: mapToggle ? 
      GoogleMap(
        myLocationEnabled: false, //Navigate to current user location
        
        //onMapCreated: _onMapCreated,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
       
          
        },
        mapType: MapType.hybrid,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(user.lati),double.parse(user.longti)),
          zoom: 14,
        ),
        markers: Set.from(markers),        

      ):
      Center(child: Text('Loading....Please wait...', 
      style: TextStyle(fontSize: 20),),)
    );
  }
  
      Marker userHome = Marker(
      markerId: MarkerId('Home'),
      infoWindow: InfoWindow(title: 'Home'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRose,),  
      );  //User home marker 
      Marker petSitter = Marker(
      markerId: MarkerId('Pet Sitters'),
      position: LatLng(35.601790, -97.481890),
      infoWindow: InfoWindow(title: 'Pet Sitter'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen,
      ),
    );




}


