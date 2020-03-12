import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewGoogleMap extends StatefulWidget {
  @override
  State<ViewGoogleMap> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<ViewGoogleMap> {
  GoogleMapController mapController;

  LatLng _center;

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = (controller);
    });
  }

  void _getGps() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = new LatLng(position.latitude, position.longitude);
    });
    print("Lat: " + position.latitude.toString());
    print("Lon: " + position.longitude.toString());
  }

  @override
  void initState() {
    super.initState();
    _getGps();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {Navigator.pop(context)}),
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: _center == null
            ? Center(child: CircularProgressIndicator())
            : GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 8.0,
                ),
              ),
      ),
    );
  }
}
