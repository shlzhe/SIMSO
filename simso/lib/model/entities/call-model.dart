class Call {
  String callerUid;
  String receiverUid;
  bool callAccepted;
  bool callStatus;
  Call(this.callerUid, this.receiverUid, this.callAccepted,this.callStatus);
  Call.clone(Call b){
    this.callerUid = b.callerUid;
    this.receiverUid = b.receiverUid;
    this.callAccepted = b.callAccepted;
    this.callStatus = b.callStatus;
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


}