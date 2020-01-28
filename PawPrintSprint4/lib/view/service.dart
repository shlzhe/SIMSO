import 'package:PawPrint/controller/service_controller.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/user.dart';
import 'package:flutter/material.dart';

class Service extends StatefulWidget {
  final List<Pet> petList;
  final User provider;
  final User user;
  Service(this.user, this.provider, this.petList);
  @override
  State<StatefulWidget> createState() {
    return ServiceState(user, provider, petList);
  }
}

class ServiceState extends State<Service> {
  List<Pet> petList;
  List<Pet> petListcopy;

  User user;
  User provider;
  String selection = 'Boarding';
  double service;
  BuildContext context;
  ServiceController controller;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  int days=0;
  double price=0;
  ServiceState(this.user, this.provider, this.petList) {
    controller = ServiceController(this);
    petListcopy = <Pet>[]..addAll(petList);
    service=provider.boardingRate;
    price = service*(days+1);
  }
  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select a service',
          style: TextStyle(fontSize: 25, fontFamily: 'Modak'),
        ), //appBar title and font
        backgroundColor: Colors.green, //appBar backgroud color
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Services needed:', style: TextStyle(fontSize: 20),),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Boarding \$' + provider.boardingRate.toString()),
                      value: 'Boarding',
                      groupValue: selection,
                      onChanged: controller.selection,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Walking \$' + provider.walkingRate.toString()),
                      value: 'Walking',
                      groupValue: selection,
                      onChanged: controller.selection,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Day Care \$' + provider.dayCare.toString()),
                      value: 'DayCare',
                      groupValue: selection,
                      onChanged: controller.selection,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Drop-in Visits \$' + provider.dropInVisit.toString()),
                      value: 'DropIn',
                      groupValue: selection,
                      onChanged: controller.selection,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('House Sitting \$' + provider.houseSitting.toString()),
                      value: 'HouseSitting',
                      groupValue: selection,
                      onChanged: controller.selection,
                    ),
                  ),
                ],
              ),
              Text('Dates:', style: TextStyle(fontSize: 20),),
              FlatButton.icon(
                label: Text('Start Date: ' + startDate.toString().substring(0,10) + '\n' + startTime.toString()),
                icon: Icon(Icons.calendar_today),
                onPressed: controller.startDate,
              ),
              FlatButton.icon(
                label: Text('End Date: \n' + endDate.toString().substring(0,10) + '\n' + endTime.toString()),
                icon: Icon(Icons.calendar_today),
                onPressed: controller.endDate,
              ),
              
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            FlatButton.icon(
              label: Text('Price: '+ price.toStringAsPrecision(4), style: TextStyle(fontSize: 20, fontFamily: 'Modak', color: Colors.white)),
              icon: Icon(Icons.monetization_on, color: Colors.white,),
              onPressed: controller.calculatePrice,
            ),
            FlatButton.icon(
              onPressed: controller.scheduleService, 
              icon: Icon(Icons.arrow_forward, color: Colors.white,), 
              label: Text('Schedule service', style: TextStyle(fontSize: 20, fontFamily: 'Modak', color: Colors.white)),
            ),
          ],
        ),
              color: Colors.green,
      ),
    );
  }
}
