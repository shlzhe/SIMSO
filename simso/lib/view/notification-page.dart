import 'package:flutter/material.dart';
import 'package:simso/model/entities/friend-model.dart';
import 'package:simso/model/entities/friendRequest-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simso/model/services/friend-service.dart' ;
import 'package:simso/model/services/ifriend-service.dart' ;

import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';


class NotificationPage extends StatelessWidget {

  final UserModel userModel;
  final List<FriendRequests> friendRequest;
 final List<UserModel> userList = new List<UserModel>();
  
  final IFriendService friendService = locator<IFriendService>();

  NotificationPage(this.userModel , this.friendRequest);

  @override
  Widget build(BuildContext context) {
   
    return Scaffold (

      appBar: AppBar(
        title: Text('My Friend Requests'),
      ),
      body: new
       ListView.builder(
        itemCount: friendRequest.length,
        itemBuilder: (context, index) {
          FriendRequests friendUser = friendRequest[index] ;
         return new ListTile(  
                    leading: CircleAvatar(
                     child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: friendRequest[index].profilePic != null &&
                                  friendRequest[index].profilePic != ''
                            ? friendRequest[index].profilePic
                            : DesignConstants.profile,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.account_circle),
                ),
              ),
                    ),
                    title: new Text('${friendRequest[index].username}'),
                    subtitle: Text('${friendRequest[index].aboutme}'),

                    onTap: () {
                      _showDialog(context, friendUser).then(
                      (value) {
                        var mySnackbar =
                            SnackBar(content: Text("..."));
                        Scaffold.of(context).showSnackBar(mySnackbar);
                      },
                    );

                    },
                  );
                })
          
        
      );
  }

 Future<String> _showDialog(BuildContext context, FriendRequests friendRequest) {
    return showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          title: new Text('${friendRequest.username}'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                _declineRequest(friendRequest);
                Navigator.of(context).pop();
              },
              child: new Text('Decline'),
            ),
            new FlatButton(
              onPressed: () {
                _acceptRequest(friendRequest);
                Navigator.of(context).pop();
              },
              child: new Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _acceptRequest(FriendRequests friendUser) async {
    friendService.addFriend(userModel, friendUser);
  }

  Future<void> _declineRequest(FriendRequests friendUser) async {
    friendService.declineFriend(userModel, friendUser);
  }
}