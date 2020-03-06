import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simso/controller/mainChatPage-controller.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/navigation-drawer.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';

class MainChatPage extends StatefulWidget {
  final UserModel user;
  final List<UserModel>userList;
  MainChatPage(this.user,this.userList);
  
  @override
  State<StatefulWidget> createState() {
    return MainChatPageState(user,userList);
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
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool publicFlag = false;
  MainChatPageState(this.user,this.userList) {
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
          
          publicFlag==false?  new RaisedButton.icon(        //if...
            icon: Icon(Icons.public), 
            label: Text('Public'),
            textColor: DesignConstants.blue,
            onPressed: controller.showUsers, 
             )  
             :   //else...
             /*
             Fluttertoast.showToast(
               msg: "Public Mode",
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.CENTER,
               timeInSecForIos: 1,
               backgroundColor: DesignConstants.yellow,
               textColor: DesignConstants.blue,
               fontSize: 16,
          
             ),
             */
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
                 )) 
          ],
          
      ),
        ),
        
      )
     
     
      
    );
}
}