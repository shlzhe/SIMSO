import 'package:cached_network_image/cached_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simso/controller/mainChatPage-controller.dart';
import 'package:simso/controller/personalChatPage-controller.dart';
import 'package:simso/model/entities/call-model.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/entities/myfirebase.dart';
import 'package:simso/model/services/icall-service.dart';
import 'package:simso/model/services/itouch-service.dart';
import 'package:simso/view/navigation-drawer.dart';
import 'package:simso/view/call-screen-page.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/services/itimer-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';
import 'design-constants.dart';
import '../model/entities/globals.dart' as globals;

class PersonalChatPage extends StatefulWidget {
  final UserModel user;
  int index; //index of selected Simso
  List<UserModel> userList;
  List<Message> filteredMessages;
  PersonalChatPage(this.user, this.index, this.userList,
      this.filteredMessages); //Receive data from mainChatPage controller

  @override
  State<StatefulWidget> createState() {
    return PersonalChatPageState(user, index, userList, filteredMessages);
  }
}

class PersonalChatPageState extends State<PersonalChatPage> {
  buildMessage(Message message, bool isMe) {
    final Container msg = Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        margin: isMe
            ? EdgeInsets.only(top: 8, bottom: 8, left: 150)
            : EdgeInsets.only(top: 8, bottom: 8),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: isMe ? Colors.white : DesignConstants.blueGreyish,
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            !isMe
                ? CachedNetworkImage(
                    imageUrl: userList[index].profilePic == null
                        ? ''
                        : userList[index].profilePic,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.tag_faces),
                    fit: BoxFit.scaleDown,
                    height: 32,
                  )
                : CachedNetworkImage(
                    imageUrl: user.profilePic == null ? '' : user.profilePic,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.tag_faces),
                    fit: BoxFit.scaleDown,
                    height: 32,
                  ),
            Text(message.time,
                style: isMe
                    ? TextStyle(
                        color: DesignConstants.blueGreyish,
                        fontStyle: FontStyle.italic)
                    : TextStyle(
                        color: DesignConstants.blue,
                        fontStyle: FontStyle.italic)),
            Text(message.text,
                style: isMe
                    ? TextStyle(color: DesignConstants.blue, fontSize: 20)
                    : TextStyle(color: DesignConstants.yellow, fontSize: 20)),
          ],
        ));
    if (isMe) {
      return msg;
    } //Display message only if it is me
    return Row(
      children: <Widget>[
        msg, //Display message & iconbutton if it is other
        IconButton(
          icon: message.isLike
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          iconSize: 30,
          color: message.isLike ? Colors.red : DesignConstants.blueLight,
          onPressed: () => controller.favMessage(message),
        )
      ],
    );
  }

  List<Message> messageCollecion;
  Message mesaage;
  BuildContext context;
  IUserService userService = locator<IUserService>();
  ITimerService timerService = locator<ITimerService>();
  ITouchService touchService = locator<ITouchService>();
  ICallService callService = locator<ICallService>();
  PersonalChatPageController controller;
  UserModel user;
  Call call;
  int index;
  String returnedID;
  var idController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool publicFlag = false;
  List<UserModel> userList;
  List<Message> filteredMessages;
  var checkUnreadList = List<bool>();
  var checkUnreadListPublic = List<bool>();
  List<String> latestMessages = List<String>();
  List<String> latestDateTime = List<String>();
  List<UserModel> friendList;
  PersonalChatPageState(
      this.user, this.index, this.userList, this.filteredMessages) {
    controller = PersonalChatPageController(this);
  }
  var c = TextEditingController();
  String result = "";
  String text = "initial";
  void stateChanged(Function f) {
    setState(f);
  }

  @override
  void initState() {
    c.addListener(() {
      final text = c.text.toLowerCase();
      c.value = c.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty);
    });
    super.initState();
  }

  @override
  void dispose() {
    c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    globals.context = context;
    return Scaffold(
      backgroundColor: DesignConstants.blue,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: new Row(
          children: <Widget>[
            new Column(
              children: <Widget>[
                //Display profile picture
                userList[index].profilePic == null || userList[index].profilePic ==''
                    ? Icon(Icons.tag_faces)
                    : CachedNetworkImage(
                        imageUrl: userList[index].profilePic, height: 30,
                        placeholder: (context, url)=>CircularProgressIndicator(),
                      ),
                        
                //Display username
                Text(
                  '${userList[index].username}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
              //Text('${userList[index].username} '),
            ),
            IconButton(
                icon: Icon(
                  Icons.call,
                  color: DesignConstants.yellow,
                ),
                onPressed: () async => {
                      await _handleCameraAndMic(),
                      call =
                          new Call(user.uid, userList[index].uid, false,user.email,user.profilePic),
                      callService.addCall(call),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreenPage(call),
                        ),
                      ),
                    }),
            IconButton(
                icon: Icon(
                  Icons.video_call,
                  color: DesignConstants.yellow,
                ),
                onPressed: () async => {
                      await _handleCameraAndMic(),
                      call =
                          new Call(user.uid, userList[index].uid, true,user.email,user.profilePic),
                      callService.addCall(call),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreenPage(call),
                        ),
                      ),
                    }),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        backgroundColor: DesignConstants.blue,
      ),
      body: //Text('Personal Chat Screen with SimSo index $index'),

          Column(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            iconSize: 30,
            color: Colors.yellow,
            onPressed: controller.checkAllRead,
          ),
          Text('Click to check all read',
              style:
                  TextStyle(color: Colors.yellow, fontStyle: FontStyle.italic)),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: DesignConstants.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: filteredMessages.length != 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 15),
                      itemCount: filteredMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Message message = filteredMessages[index];
                        final bool isMe = message.sender == user.uid;
                        //return Text(filteredMessages[index].text, style: TextStyle(color:DesignConstants.yellow, fontSize: 20));
                        return (buildMessage(message, isMe));
                      })
                  : Text('start a very first message....',
                      style: TextStyle(
                          color: DesignConstants.yellow, fontSize: 20)),
            ),
          ),

          Form(
            key: formKey,
            child: TextFormField(
                scrollPadding: EdgeInsets.all(8),
                decoration: InputDecoration(
                  hintText: 'start typing...',
                  hintStyle: TextStyle(color: DesignConstants.yellow),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: DesignConstants.yellow, width: 3)),
                  labelStyle: TextStyle(color: DesignConstants.yellow),
                ),
                validator: controller.validateTextMessage,
                onSaved: controller.saveTextMessage,
                controller: c, //to delete sent msg after clicking send

                style: TextStyle(
                    color: DesignConstants.yellow,
                    fontStyle: FontStyle.italic)),
          ),

          //Text('${filteredMessages.length}'),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: DesignConstants.yellow,
                ),
                onPressed: controller.send,
              ),
            ],
          ),
          //------------------------------------------------------------

          //Show message
        ],
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
