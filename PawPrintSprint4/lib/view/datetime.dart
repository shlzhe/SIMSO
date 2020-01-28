import 'package:flutter/material.dart';

class DateSelection extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DateSelectionState();
      }
    
    }
    
    class DateSelectionState extends State<DateSelection>{
      DateTime now = DateTime.now();
      DateTime date = DateTime.now();
      TimeOfDay time = TimeOfDay.now();
      Future<Null> selectdate(BuildContext context) async{
        final DateTime picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2019),
          lastDate: DateTime(2021),
        );
        if (picked != null && picked != date){
          print('Date selected: ${date.toString()}');
          setState(() {
            date = picked;
          });
        }
      }
      Future<Null> selecttime(BuildContext context) async{
        final TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null && picked != time){
          print('Date selected: ${date.toString()}');
          setState(() {
            time = picked;
          });
        }
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date'),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Select Date'),
              onPressed: (){selectdate(context);},
            ),
            date == now ? null :
            Text('Date selected: ${date.toString()}'),
            RaisedButton(
              child: Text('Select Time'),
              onPressed: (){selecttime(context);},
            ),
            Text('Time selected: ${time.toString()}'),
          ],
        ),
      ),
    );
  }
}