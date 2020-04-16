// For storing variables needed throughout the app
library simso.globals;

import 'package:simso/model/entities/call-model.dart';
import 'package:simso/model/entities/limit-model.dart';
import 'package:simso/model/entities/timer-model.dart';
import 'package:simso/model/entities/touch-counter-model.dart';

TimerModel timer;
TouchCounterModel touchCounter;
LimitModel limit;
Call call;

DateTime getDate(String dateString) {
  var firstDashIndex = dateString.indexOf('/', 1);
  var secondDashIndex = dateString.indexOf('/', 2);

  var month = int.parse(dateString.substring(0, firstDashIndex));
  var day = int.parse(dateString.substring(firstDashIndex + 1, secondDashIndex));
  var year = int.parse(dateString.substring(secondDashIndex + 1));

  return new DateTime(year, month, day);
}