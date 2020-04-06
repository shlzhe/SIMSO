import 'package:cached_network_image/cached_network_image.dart';
import 'package:simso/controller/mainChatPage-controller.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';

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
  MainChatPageState(this.user,this.userList,this.currentIndex) {
    controller = MainChatPageController(this);
  
  }

  void stateChanged(Function f) {
    setState(f);
  }
 
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
    
      appBar: AppBar(
        title: Text('SimSo Together'),
        backgroundColor: DesignConstants.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: controller.backButton,
          ),
          
      ),
      body: new Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),   //Top center raise buttin
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
                     padding: EdgeInsets.all(5.0),
                     height: 100,
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
                                        
                              ],
                            ),
                            onTap: ()=>controller.onTap(index),
                          )
                          
                          );
                 }
                 )),
           //-----------------------------------------------------------------------
          //FRIEND MODE
            friendFlag == false ? 
            RaisedButton.icon(
            icon: Icon(Icons.local_florist), 
            label: Text('Friends'),
            textColor: DesignConstants.blue,
            onPressed: controller.showFriends,
            )
            :
            //else
            Expanded(
               child: 
               ListView.builder(
                 itemCount: userList[currentIndex].friends.length, 
                 itemBuilder: (BuildContext context, int index){
                   return Container(
                     padding: EdgeInsets.all(5.0),
                     height: 100, 
                    child: 
                     
                    ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: userList[index].profilePic == null ? '': userList[index].profilePic,
                            placeholder: (context, url)=>CircularProgressIndicator(),
                            errorWidget: (context, url, error)=> Icon(Icons.tag_faces),
                            ),
                            title: Text(userList[index].username,), 
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                Text(userList[index].email),
                                Text(userList[index].city == null ? '': userList[index].city),        
                              ],
                            ),
                            onTap: ()=>controller.onTap(index),
                          )
                          
                          );
                 }
                 )),
          //-----------------------------------------------------------------------
          
          
          ],
      
      ),
        ),
        
      )
     
     
      
    );
}
}