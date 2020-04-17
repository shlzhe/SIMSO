import 'package:flutter/material.dart';
import 'package:simso/model/entities/friend-model.dart';
import 'package:simso/model/entities/friendRequest-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:simso/model/services/friend-service.dart' ;
import 'package:simso/model/services/ifriend-service.dart' ;
import '../model/entities/globals.dart' as globals;

import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';


class NotificationPage extends StatefulWidget {

  final UserModel userModel;
  final List<FriendRequests> friendRequest;

  NotificationPage(this.userModel , this.friendRequest);

  @override
  State<StatefulWidget> createState() {
    return _NotificationPageState(userModel, friendRequest);
  }
}



class _NotificationPageState extends State<NotificationPage> {
 final List<UserModel> userList = new List<UserModel>();
UserModel userModel;
 List<FriendRequests> friendRequest;
_NotificationPageState state;
  final IFriendService friendService = locator<IFriendService>();


 _NotificationPageState(this.userModel, this.friendRequest);
 


  void stateChanged(Function f) {
    setState(f);
  }
@override
  void initState() {
    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    globals.context = context;
    return Scaffold (

      appBar: AppBar(
        title: Text('My Friend Requests'),
      ),
      body: new
       ListView.builder(
        itemCount: widget.friendRequest.length,
        itemBuilder: (context, index) {
          FriendRequests friendUser = widget.friendRequest[index] ;
         return new ListTile(  
                    leading: CircleAvatar(
                     child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.friendRequest[index].profilePic != null &&
                                  widget.friendRequest[index].profilePic != ''
                            ? widget.friendRequest[index].profilePic
                            : DesignConstants.profile,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.account_circle),
                ),
              ),
                    ),
                    title: new Text('${widget.friendRequest[index].username}'),
                    subtitle: Text('${widget.friendRequest[index].aboutme}'),

                    onTap: () async {
                      _showDialog(context, friendUser).then(
                      (value) {
                        var mySnackbar =
                            SnackBar(content: Text("..."));
                        Scaffold.of(context).showSnackBar(mySnackbar);
                       setState(() {
                  widget.friendRequest.removeAt(index);
                   });
  
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
    friendService.addFriend(widget.userModel, friendUser);
  }

  Future<void> _declineRequest(FriendRequests friendUser) async {
    friendService.declineFriend(widget.userModel, friendUser);
  }


  void init() async {
   
 }

}