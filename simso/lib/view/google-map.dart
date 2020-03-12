
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simso/model/entities/friend-model.dart';


class ViewGoogleMap extends StatefulWidget {
  final List<Friend> friends;
  ViewGoogleMap(this.friends);

  @override
  State<ViewGoogleMap> createState() => _GoogleMapState(friends);
}

class _GoogleMapState extends State<ViewGoogleMap> {
  GoogleMapController mapController;
  LatLng _center;
  Set<Marker> _markers = {};
  List<Friend> _friends;

  _GoogleMapState(this._friends);

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
    _getFriendLocation(_center);
    //test address
    // List<Placemark> placemark =
    //     await Geolocator().placemarkFromAddress("Seattle");
    // print(placemark[0].country);
    // print(placemark[0].position);
    // print(placemark[0].locality);
    // print(placemark[0].administrativeArea);
    // print(placemark[0].postalCode);
    // print(placemark[0].name);
    // print(placemark[0].subAdministrativeArea);
    // print(placemark[0].isoCountryCode);
    // print(placemark[0].subLocality);
    // print(placemark[0].subThoroughfare);
    // print(placemark[0].thoroughfare);
  }

  void _getFriendLocation(LatLng userPosition) async {
    List<Placemark> userPlacemark = await Geolocator().placemarkFromCoordinates(
        userPosition.latitude, userPosition.longitude);
    for (var i in _friends) {
      List<Placemark> friendPlacemark =
          await Geolocator().placemarkFromAddress(i.city);
      if (userPlacemark[0].administrativeArea ==
          friendPlacemark[0].administrativeArea) {
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(friendPlacemark[0].position.toString()),
            position: new LatLng(friendPlacemark[0].position.latitude,
                friendPlacemark[0].position.longitude),
            infoWindow: InfoWindow(
              title: i.username,
              snippet: 'City: ${i.city}',
              onTap: () => {print("Inside infoWindow")},
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        });
      }
    }
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
          title: Text('Friends Near Me'),
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
                markers: _markers,
                zoomGesturesEnabled: true,
              ),
      ),
    );
  }
}
