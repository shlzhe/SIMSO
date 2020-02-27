import 'package:flutter/material.dart';
import 'package:simso/model/entities/limit-model.dart';
import 'package:simso/view/design-constants.dart';

class TimeDialog {

  static String displayTime(timeInMins) {
    String hours;
    String mins;
    var intHours = (timeInMins / 60).truncate();
    if (intHours == 0)
      hours = '00';
    else if (intHours < 10)
      hours = '0' + hours.toString();
    else 
      hours = hours.toString();
    var intMins = (timeInMins / 60).truncate();
    if (intMins == 0)
      mins = '00';
    else if (intMins < 10)
      mins = '0' + hours.toString();
    else 
      mins = mins.toString();
    return hours + ':' + mins;
  }

  static void info(
    {
      @required BuildContext context,
      @required LimitModel limit,
      @required bool timeReached,
    }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(timeReached ? 'Time' : 'Touch' + ' limit exceded!'),
          content: Container(
            height: 120,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.error,
                  size: 50,
                  color: Colors.red,
                ),
                Expanded(child: 
                  Text(
                    'You set a time limit of ' + 
                    (timeReached ?
                      displayTime(limit.timeLimitMin) : 
                      limit.touchLimit.toString() + ' touches') + 
                    '. Would you like to close the app?')
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
              color: DesignConstants.blueLight,
              onPressed: (){Navigator.pop(context);},
            ),
          ],
        );
      },
    );
  }
}
