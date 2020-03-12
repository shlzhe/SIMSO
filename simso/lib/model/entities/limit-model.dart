class LimitModel {
  LimitModel({
    this.documentID, 
    this.userID, 
    this.overrideThruDate, 
    this.lastUpdated, 
    this.timeLimitMin, 
    this.touchLimit});

  String documentID;
  String userID;
  String overrideThruDate;
  String lastUpdated;
  int timeLimitMin;
  int touchLimit;

    // From object to map for Firebase  
  Map<String, dynamic> serialize() => 
  {
    USER_ID: userID,
    OVERRIDE_THRU_DATE: overrideThruDate,
    LAST_UPDATED: lastUpdated,
    TIME_LIMIT_MIN: timeLimitMin,
    TOUCH_LIMIT: touchLimit
  };

  // Map from Firebase to object
  LimitModel.deserialize(Map<String, dynamic> map, String docID) :
    documentID = docID,
    userID = map[USER_ID],
    overrideThruDate = map[OVERRIDE_THRU_DATE],
    lastUpdated = map[LAST_UPDATED],
    timeLimitMin = map[TIME_LIMIT_MIN],
    touchLimit = map[TOUCH_LIMIT];

  // Fields
  static const USER_ID = 'userID';
  static const OVERRIDE_THRU_DATE = 'overrideThruDate';
  static const LAST_UPDATED = 'lastUpdated';
  static const TIME_LIMIT_MIN = 'timeLimitMin';
  static const TOUCH_LIMIT = 'touchLimit';
}