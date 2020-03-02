import 'package:simso/model/services/itouch-service.dart';

import '../../service-locator.dart';

class TouchCounterModel {
  TouchCounterModel({this.documentID, this.userID, this.day, this.touches});

  String documentID;
  String userID;
  String day;
  int touches;

  // Service for updating timer
  ITouchService touchService = locator<ITouchService>();

  void addOne() {
    this.touches++;
    this.touchService.updateTouchCounter(this);
  }
  
  // From object to map for Firebase  
  Map<String, dynamic> serialize() => 
  {
    USER_ID: userID,
    DAY: day,
    TOUCHES: touches
  };

  // Map from Firebase to object
  TouchCounterModel.deserialize(Map<String, dynamic> map, String docID) :
    documentID = docID,
    userID = map[USER_ID],
    day = map[DAY],
    touches = map[TOUCHES];

  // Fields
  static const USER_ID = 'userID';
  static const DAY = 'day';
  static const TOUCHES = 'touches';
}