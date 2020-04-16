import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/entities/friend-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/google-map.dart';
import 'package:simso/model/services/ifriend-service.dart' ;
import 'package:simso/view/navigation-drawer.dart' ;
import 'design-constants.dart';
import '../service-locator.dart';
import '../view/profile-page.dart';
import '../model/services/iuser-service.dart' ;



class FriendPage extends StatefulWidget {
  final UserModel userModel;
  final List<Friend> friends;
 
  FriendPage(this.userModel, this.friends);

  @override
   State<StatefulWidget> createState() {
    return _FriendPageState(userModel,friends);
  }
}



class _FriendPageState extends State<FriendPage> {
  IUserService userService = locator<IUserService>();
 UserModel userModel2;
  IFriendService friendService = locator<IFriendService>();
 List<Friend> friend2;
 UserModel friend;
 BuildContext context;
 _FriendPageState state;
 
 var loading = true;

   _FriendPageState  (this.userModel2, this.friend2) {
     
    // init();
   }
   
   
   void stateChanged(Function f){
    setState(f);
  }

 @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    this.context = context ;

    return Scaffold(
        appBar: AppBar(
          title: Text('My Friends'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.map),
              onPressed: ()=>{
                Navigator.push(context, MaterialPageRoute(builder:(context)=> ViewGoogleMap(widget.friends)))
              },
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: widget.friends.length,
            itemBuilder: (context, index) {
               Friend friend2 = widget.friends[index];
              return new ListTile(
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.friends[index].profilePic != null &&
                                widget.friends[index].profilePic != ''
                            ? widget.friends[index].profilePic
                            : DesignConstants.profile,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.account_circle),
                      ),
                    ),
                  ),
                title: new Text('${widget.friends[index].username}'),
                subtitle: Text('${widget.friends[index].aboutme}'),
                  onTap: () async {
                      _showDialog(context, friend2).then(
                      (value) {
                        var mySnackbar =
                            SnackBar(content: Text("..."));
                        Scaffold.of(context).showSnackBar(mySnackbar); 
                         setState(() {
                       widget.friends.removeAt(index);
                   });
                     },
                     
                    );

                    },
                  );
                })
          
        
      );
  }

void init() async {
 
 //state.friend2 =  await friendService.getFriends(state.widget.friends);
 
  }


void navigateProfile(String uid) async {
   UserModel goToUser = await userService.readUser(uid);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ProfilePage(goToUser, true)
    ));
    
  }


  Future<String> _showDialog(BuildContext context, Friend friend) {
    return showDialog(
      context: context,
      builder: (context,) {
        return new AlertDialog(
          title: new Text('${friend.username}'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                _deleteFriend(friend);
                Navigator.of(context).pop();
              },
              
              child: new Text('Delete Friend'),
            ),
            new FlatButton(
              onPressed: () {
                navigateProfile(friend.uid);
                Navigator.of(context).pop();
                
              },
              child: new Text('View Profile'),
            ),
          ],
        );
      },
    );
  }


Future<void> _deleteFriend(Friend friendUser) async {
    friendService.deleteFriend(widget.userModel, friendUser);
     }

}

