import 'package:flutter/material.dart';
import 'package:simso/controller/add-limits-page-controller.dart';
import 'package:simso/model/entities/limit-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/ilimit-service.dart';

import '../service-locator.dart';
import 'design-constants.dart';

class AddLimitsPage extends StatefulWidget {
  final UserModel user;
  final LimitModel limit;


  AddLimitsPage(this.user, this.limit);

  @override
  State<StatefulWidget> createState() {
    return AddLimitsPageState(user, limit);
  }
}

class AddLimitsPageState extends State<AddLimitsPage> {
  UserModel user;
  LimitModel limit;
  AddLimitsPageController controller;
  ILimitService limitService = locator<ILimitService>();
  var formKey = GlobalKey<FormState>();
  var hourController = TextEditingController(text: '00');
  var minuteController = TextEditingController(text: '00');
  var touchController = TextEditingController(text: '00');

  AddLimitsPageState(this.user, this.limit) {
    controller = AddLimitsPageController(this, this.limitService);
    if (this.limit.touchLimit != null && this.limit.touchLimit > 0)
      touchController.text = this.limit.touchLimit.toString();
    
    if (this.limit.timeLimitMin != null && this.limit.timeLimitMin > 0) {
      var minInt = (this.limit.timeLimitMin % 60);
      String minString = minInt.toString();
      if (minInt < 10)
        minString = '0' + minInt.toString();

      var hourInt = (this.limit.timeLimitMin / 60).truncate();
      String hourString = hourInt.toString();
      if (hourInt < 10)
        hourString = '0' + hourInt.toString();

      minuteController.text = minString;
      hourController.text = hourString;
    }
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Limits'),
        backgroundColor: DesignConstants.blueLight,
      ),
      backgroundColor: DesignConstants.blue,
      body: Container(
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 55),
                    child: Text(
                  'Time Limit',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 35, right: 10),
                  width: 75,
                  child: TextFormField(
                    controller: hourController,
                    onChanged: controller.hoursChanged,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white, fontSize: 48),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white),
                      ),
                    ),
                    onSaved: controller.saveHours,
                    keyboardType: TextInputType.number
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: 
                    Text(':', style: TextStyle(fontSize: 48, color: Colors.white),)),
                Container(
                  margin: EdgeInsets.only(top: 35, left: 10),
                  width: 75,
                  child: TextFormField(
                    onChanged: controller.minutesChanged,
                    controller: minuteController,
                    style: TextStyle(color: Colors.white, fontSize: 48),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white),
                      ),
                    ),
                    onSaved: controller.saveMinutes,
                    keyboardType: TextInputType.number
                  ),
                ),
              ],),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                    child: Text(
                  '   hours              minutes',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 55),
                    child: Text(
                  'Touch Limit',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                )),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 25, right: 10),
                  width: 75,
                  child: TextFormField(
                    controller: touchController,
                    onChanged: controller.touchesChanged,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 48),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white),
                      ),
                    ),
                    onSaved: controller.saveTouches,
                    keyboardType: TextInputType.number
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                    child: Text(
                  'touches  ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    color: DesignConstants.blueLight,
                    child: Text('Save Limits', style: TextStyle(color: Colors.white, fontSize: 18),),
                    onPressed: controller.saveLimits,
                  ),
                ),)
            ],
          ),
        ),
      ),
    );
  }
}
