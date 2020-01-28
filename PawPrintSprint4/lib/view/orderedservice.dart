import 'package:PawPrint/controller/orderedservice_controller.dart';
import 'package:PawPrint/model/saveservice.dart';
import 'package:PawPrint/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderedService extends StatefulWidget{
  final User user;
  final List<OrderService> orderService;
  OrderedService(this.user, this.orderService);
  @override
  State<StatefulWidget> createState() {
    return OrderedServiceState(user, orderService);
      }
    }
    
    class OrderedServiceState extends State<OrderedService> {
      User user;
      List<OrderService> orderService;
      BuildContext context;
      OrderedServiceController controller;
      List<int> deleteIndices;
      bool deleteMode = false;
      OrderedServiceState(this.user, this.orderService){
        controller = OrderedServiceController(this);
      }
      void stateChanged(Function f){
        setState(f);
      }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ordered Service',style: TextStyle(fontSize: 30,fontFamily: 'Modak'),),
          backgroundColor: Colors.green,
        actions: 
          deleteMode == true ? <Widget>[
          FlatButton.icon(
            label: Text('Delete'),
            icon: Icon(Icons.delete_forever),
            onPressed: controller.delete,
          )] : null,
      ),
      body: 
      ListView.builder(
        itemCount: orderService.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.all(5),
            color: deleteIndices != null && deleteIndices.contains(index) ?
                  Colors.cyan : Colors.grey,
            child: ListTile(
            title: Text(orderService[index].service+':', style: TextStyle(fontFamily: 'Modak')),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('     '+orderService[index].price.toString()),
                Text('     '+orderService[index].numofpets.toString()),
                Text('     '+orderService[index].ownerEmail),
                Text('     '+orderService[index].address),
              ],
            ),
            onTap: ()=>controller.onTap(index),
            onLongPress: ()=>controller.onLongPress(index),
            ),
          );
        },
      ),
      backgroundColor: Colors.grey,
    );
  }
}