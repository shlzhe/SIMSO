import 'package:flutter/cupertino.dart';
import 'package:simso/model/entities/limit-model.dart';
import 'package:simso/model/services/ilimit-service.dart';
import 'package:simso/view/add-limits-page.dart';
import '../model/entities/globals.dart' as globals;

class AddLimitsPageController {
  AddLimitsPageState state;
  ILimitService limitService;
  AddLimitsPageController(this.state, this.limitService);

  int hours;
  int minutes;
  int touches;

  void saveHours(String value) {
    if (value.isEmpty)
      this.hours = 0;
    else 
      this.hours = int.parse(value);
  }

  void hoursChanged(String value) {
    try {
      var intValue = int.parse(value);
      if (intValue > 23)
        state.hourController.text = '23';
    } catch (e) {
      state.hourController.text = '';
    }
  }

  void saveMinutes(String value) {
    if (value.isEmpty)
      this.minutes = 0;
    else 
      this.minutes = int.parse(value);
  }

  void minutesChanged(String value) {
    
    try {
      var intValue = int.parse(value);
      if (intValue > 59)
        state.minuteController.text = '59';
    } catch (e) {
      state.minuteController.text = '';
    }
  }

  void saveTouches(String value) {
    if (value.isEmpty)
      this.touches = 0;
    else 
      this.touches = int.parse(value);
  }

  void touchesChanged(String value) {
    try {
      int.parse(value);
    } catch (e) {
      state.touchController.text = '';
    }
  }

  void saveLimits() async {
    state.formKey.currentState.save();
    state.limit.touchLimit = touches;
    state.limit.timeLimitMin = (minutes + 60 * hours);

    try {
      await limitService.updateLimit(state.limit);
      globals.limit = new LimitModel.deserialize(state.limit.serialize(), state.limit.documentID);
      Navigator.pop(state.context);
    } catch (e){
      print(e);
    }
  }
}