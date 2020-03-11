import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simso/model/entities/friend-model.dart';
import 'package:simso/model/entities/user-model.dart';

import 'design-constants.dart';

class FriendPage extends StatelessWidget {
  final UserModel userModel;
  final List<Friend> friends;

  FriendPage(this.userModel, this.friends);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Friends'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.map),
              onPressed: ()=>{
                Navigator.push(context, MaterialPageRoute(builder:(context)=> _gooleMap()))
              },
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return new ListTile(
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: friends[index].profilePic != null &&
                                friends[index].profilePic != ''
                            ? friends[index].profilePic
                            : DesignConstants.profile,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.account_circle),
                      ),
                    ),
                  ),
                  title: new Text('${friends[index].username}'),
                  subtitle: Text('${friends[index].aboutme}'),
                  onTap: null);
            }));
  }
}

class _gooleMap extends StatelessWidget {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
