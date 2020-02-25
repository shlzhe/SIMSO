import 'package:flutter/material.dart';
import 'package:simso/model/services/ifriend-service.dart';

class RecommendFriends extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecommendFriendsState();
  }
}

class RecommendFriendsState extends State<RecommendFriends> {
  IFriendService _friendService;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(future: _friendService.getFriend() , builder: (_context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Waiting..."),
          );
        } else {
          return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    snap.data[index].data('email'),
                  ),
                );
              });
        }
      }),
    );
  }
}
