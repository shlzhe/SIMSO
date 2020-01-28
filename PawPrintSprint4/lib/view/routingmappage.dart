import 'dart:async';
import 'package:PawPrint/controller/routingmappage_controller.dart';
import 'package:PawPrint/model/user.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RoutingMapPage extends StatefulWidget {
  final User user;
  final String selectedPetsitter;
  final String latiPetSitter;
  final String longtiPetSitter;
//Constructor
  RoutingMapPage(this.user,this.selectedPetsitter,this.latiPetSitter,this.longtiPetSitter);
  @override
  State<StatefulWidget> createState() {
    return RoutingMapPageState(user,selectedPetsitter,latiPetSitter,longtiPetSitter);
  }
}

class RoutingMapPageState extends State<RoutingMapPage> {
  static var location = new Location();
  Completer<GoogleMapController> _controller = Completer();


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  User user;
  final String selectedPetsitter;
  final String latiPetSitter;
  final String longtiPetSitter;
  RoutingMapPageController controller;
  BuildContext context;

  List<int> deleteIndices; //fore delete books

  RoutingMapPageState(this.user,this.selectedPetsitter, this.latiPetSitter,this.longtiPetSitter) {
    controller = RoutingMapPageController(this);

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
 
  List<String> documentList;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(     
      appBar: AppBar(
        title: Text ('Naviagtion Page'),
        backgroundColor:  Colors.green,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(user.lati), double.parse(user.longti)),
          zoom: 14.0, 
        ),
        markers: {
          userHome = Marker(
          markerId: MarkerId('Home'),
          position: LatLng(double.parse(user.lati),double.parse(user.longti)),  //only static can e used
          infoWindow: InfoWindow(title: 'Home'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRose,),
          onTap: (){},
          ),
        
        petSitter = Marker(
        markerId: MarkerId('$selectedPetsitter'),
        position: LatLng(double.parse(latiPetSitter),double.parse(longtiPetSitter)),
        infoWindow: InfoWindow(title: '$selectedPetsitter'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
        ),
        onTap:controller.petSitterTapped,
        )
      },
      mapType: MapType.normal,
      myLocationEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
    ),
    
    floatingActionButton: Padding(
      padding: const EdgeInsets.all(50),
      child: FloatingActionButton.extended(
          onPressed: toThePetSitterPlace,
          label: Text('Pet Sitter!'),
          icon: Icon(Icons.directions),
          backgroundColor: Colors.green,
      ),
    )     
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
      infoWindow: InfoWindow(title: 'Pet Sitter'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
      ),
    );

 Future<void> toThePetSitterPlace() async {
    print('floating button clicked');
   // print(latiPetSitter);
    final CameraPosition _kPetSitter = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(double.parse(latiPetSitter), double.parse(longtiPetSitter)),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
      
      );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kPetSitter));
    

    
  }
}




