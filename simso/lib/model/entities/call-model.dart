import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/model/services/call-service.dart';
import 'package:simso/model/services/icall-service.dart';
import 'package:simso/view/call-request-page.dart';
import 'package:simso/model/entities/globals.dart' as global;
import 'package:simso/view/call-screen-page.dart';

import '../../service-locator.dart';

class Call {
  String callerUid;
  String receiverUid;
  bool callAccepted;
  bool callStatus;
  ICallService callService = locator<ICallService>();

  Call(this.callerUid, this.receiverUid, this.callAccepted, this.callStatus);
  Call.clone(Call b) {
    this.callerUid = b.callerUid;
    this.receiverUid = b.receiverUid;
    this.callAccepted = b.callAccepted;
    this.callStatus = b.callStatus;
  }
  Call.isEmpty() {
    this.callerUid = '';
    this.receiverUid = '';
    this.callAccepted = null;
    this.callStatus = null;
  }
  static const CALLERUID = 'calleruid';
  static const RECEIVERUID = 'receiveruid';
  static const CALLACCEPTED = 'callaccepted';
  static const CALLLOG = 'callLog';
  static const CALLSTATUS = 'callstatus';
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      CALLERUID: callerUid,
      RECEIVERUID: receiverUid,
      CALLACCEPTED: callAccepted,
      CALLSTATUS: callStatus,
    };
  }

  Call.deserialize(Map<String, dynamic> doc)
      : callAccepted = doc[CALLACCEPTED],
        callerUid = doc[CALLERUID],
        callStatus = doc[CALLSTATUS],
        receiverUid = doc[RECEIVERUID];

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
                        print("======inside checkCall======"),
                        if (value != null)
                          {
                            timer.cancel(),
                            global.callState = true,
                            if(global.c == 0){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallScreenPage(true, value),
                                )),
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
}
