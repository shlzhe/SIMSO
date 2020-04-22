import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simso/model/services/icall-service.dart';
import 'package:simso/model/entities/globals.dart' as global;
import 'package:simso/view/call-screen-page.dart';

import '../../service-locator.dart';
import '../../view/design-constants.dart';

class Call {
  String callerUid;
  String receiverUid;
  bool videoCall;
  String callerName;
  String callerPic;
  ICallService callService = locator<ICallService>();

  Call(this.callerUid, this.receiverUid, this.videoCall, this.callerName,
      this.callerPic);
  Call.clone(Call b) {
    this.callerUid = b.callerUid;
    this.receiverUid = b.receiverUid;
    this.videoCall = b.videoCall;
    this.callerName = b.callerName;
    this.callerPic = b.callerPic;
  }
  Call.isEmpty() {
    this.callerUid = '';
    this.receiverUid = '';
    this.videoCall = null;
    this.callerName = '';
    this.callerPic = '';
  }
  static const CALLERUID = 'calleruid';
  static const RECEIVERUID = 'receiveruid';
  static const VIDEOCALL = 'videocall';
  static const CALLLOG = 'callLog';
  static const CALLERNAME = 'callername';
  static const CALLERPIC = 'callerpic';
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      CALLERUID: callerUid,
      RECEIVERUID: receiverUid,
      VIDEOCALL: videoCall,
      CALLERNAME: callerName,
      CALLERPIC: callerPic,
    };
  }

  Call.deserialize(Map<String, dynamic> doc)
      : videoCall = doc[VIDEOCALL],
        callerUid = doc[CALLERUID],
        callerName = doc[CALLERNAME],
        receiverUid = doc[RECEIVERUID],
        callerPic = doc[CALLERPIC];

  bool callCheck;

  startCallCheck(String reUid, BuildContext context) {
    this.callCheck = true;
    var sec = Duration(seconds: 5);

    Timer.periodic(
        sec,
        (timer) => {
              if (!this.callCheck)
                {timer.cancel()}
              else
                {
                  callService.checkCall(reUid).then((value) => {
                        // print("======inside checkCall======"),
                        if (value != null)
                          {
                            timer.cancel(),
                            global.callState = true,
                            if (global.c == 0)
                              {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => AlertDialog(
                                    title: Text("Incoming Call..."),
                                    content: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          child: Text(value.callerName),
                                        ),
                                        Container(
                                          child: CircleAvatar(
                                            child: CachedNetworkImage(
                                              imageUrl: value.callerPic != ''
                                                  ? value.callerPic
                                                  : DesignConstants.profile,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Icon(Icons.account_circle),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    actions: <Widget>[
                                      new FlatButton.icon(
                                        onPressed: () => {
                                          global.callState = false,
                                          Navigator.pop(context),
                                          callService.deleteCall(value)
                                        },
                                        icon: Icon(Icons.call_end),
                                        color: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        label: Text("Reject"),
                                      ),
                                      new FlatButton.icon(
                                        onPressed: () async => {
                                          await _handleCameraAndMic(),
                                          Navigator.pop(context),
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CallScreenPage(value),
                                              )),
                                        },
                                        icon: Icon(Icons.call),
                                        color: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        label: Text("Accept"),
                                      ),
                                    ],
                                  ),
                                ),
                                global.c++,
                              },
                          }
                      })
                }
            });
  }

  stopCallCheck() {
    this.callCheck = false;
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
