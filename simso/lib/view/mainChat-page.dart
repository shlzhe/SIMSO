import 'package:cached_network_image/cached_network_image.dart';
import 'package:simso/controller/mainChatPage-controller.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';
import '../model/entities/globals.dart' as globals;

class MainChatPage extends StatefulWidget {
  final UserModel user;
  final List<UserModel>userList;
  int currentIndex;
  MainChatPage(this.user,this.userList,this.currentIndex);
  
  @override
  State<StatefulWidget> createState() {
    return MainChatPageState(user,userList,currentIndex);
  }
}

class MainChatPageState extends State<MainChatPage> {
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  MainChatPageController controller;
  UserModel user;
  List<UserModel>userList;                                //To hold all SimSO users, initialized null
  List<UserModel>friendList;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool publicFlag = false;      //True when public button is clicked
  bool friendFlag = false;      //True when friends button is clicked
  int currentIndex;         //Hold index on users collection in DB of current user
  var checkUnreadList = List<bool>();
  var checkUnreadListPublic = List<bool>();
  MainChatPageState(this.user,this.userList,this.currentIndex) {
    controller = MainChatPageController(this);
    controller.getUnreadMessages();
  }
  bool checkUnread;
  List<String> latestMessages =  List<String>();
  List<String> latestDateTime = List<String>();
  void stateChanged(Function f) {
    setState(f);
  }
  List<bool>unread=[];
  @override
  Widget build(BuildContext context) {
    this.context = context;
    globals.context = context;
    return Scaffold(
    
      appBar: AppBar(
        title: Text('SimSo Together'),
        backgroundColor: DesignConstants.blue,
       
      ),
      body: new Center(
        
        child: Padding(
          padding: const EdgeInsets.all(8.0),   //Top center raise button
          
          child: Column(  
          children: <Widget>[  
          //PUBLIC MODE
       publicFlag==false?  new RaisedButton.icon(        //if...
            icon: Icon(Icons.public), 
            label: Text('Public'),
            textColor: DesignConstants.blue,
            onPressed: controller.showUsers, 
             )  
             :   //else...
             
             Expanded(
               child: 
               ListView.builder(
                 itemCount: userList.length,
                 itemBuilder: (BuildContext context, int index){
                   
                   return Container(
                    height:100,
                    padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      border: Border.all(
                        color: DesignConstants.blue,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),   
                    child: 
                    ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: userList[index].profilePic == null ? '':userList[index].profilePic,
                            placeholder: (context, url)=>CircularProgressIndicator(),
                            errorWidget: (context, url, error)=> Icon(Icons.tag_faces),
                            ),
                            title: Text(userList[index].username,), 
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                Text(userList[index].email),
                                Text(userList[index].city == null ? '': userList[index].city),
                                checkUnreadListPublic.length == userList.length ?
                                checkUnreadListPublic[index]==false ? Text('') : Text('NEW MESSAGE',style: TextStyle(color:DesignConstants.red),)
                                : Text('') 
                              ],
                            ),
                            onTap: ()=>controller.onTapPublishMode(index),
                          )
                          
                          );
                 }
                 )),
           //-----------------------------------------------------------------------
          //FRIEND MODE
           
            friendFlag == true && friendList !=null  ?
               //if friendmode is true
            Expanded(
              
               child: 
               
               ListView.builder(
                 itemCount: friendList.length, 
                 itemBuilder: (BuildContext context, int index){
                   controller.friendIndex(friendList[index].uid);
                   
                   return Container(
                    height:120,
                    padding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      border: Border.all(
                        color: DesignConstants.blue,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),  
                     
                    child:       
                    ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: friendList[index].profilePic == null ? '': friendList[index].profilePic,
                            placeholder: (context, url)=>CircularProgressIndicator(),
                            errorWidget: (context, url, error)=> Icon(Icons.tag_faces),
                            ),
                            title: Text(friendList[index].username,), 
                           
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                Text(friendList[index].email),
                                Text(friendList[index].city == null ? '': friendList[index].city),  
                                checkUnreadList.length == friendList.length ?
                                checkUnreadList[index]==false ? Text('') : Text('NEW MESSAGE',style: TextStyle(color:DesignConstants.red),)
                                : Text('') 
                                /*

                                checkUnreadList.length == friendList.length && checkUnreadList.length == latestMessages.length ?
                                checkUnreadList[index]==false ? Text('${latestMessages[index].substring(0,15)}...',style: TextStyle(fontStyle: FontStyle.italic,color:DesignConstants.blue),) 
                                                                      : Text('${latestMessages[index].substring(0,15)}...',style: TextStyle(fontStyle: FontStyle.italic,color:DesignConstants.red),)
                                : Text(''),

                                checkUnreadList.length == friendList.length && checkUnreadList.length == latestDateTime.length ?
                                checkUnreadList[index]==false ? Text('<${latestDateTime[index]}>',style: TextStyle(fontStyle: FontStyle.italic,color:DesignConstants.blue),) 
                                                                      : Text('<${latestDateTime[index]}>',style: TextStyle(fontStyle: FontStyle.italic,color:DesignConstants.blue),)
                                : Text('')
                                */
                              ],
                          
                            ),
                            onTap: ()=>controller.onTapFriendMode(index),
                          )
                          
                          );
                 }
                 )) 
                 : //else no friends
            RaisedButton.icon(
            icon: Icon(Icons.local_florist), 
            label: Text('Friends'),
            textColor: DesignConstants.blue,
            onPressed: controller.showFriends,
            ),
          
          
          //-----------------------------------------------------------------------   
          ]    
      ),
        ),
        
      )   
    );
  }
}