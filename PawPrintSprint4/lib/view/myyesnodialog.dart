import 'package:flutter/material.dart';
class MyYesNoDialog {
  static void info({
    @required BuildContext context, 
    @required String title, 
    @required String message,
    @required Function yes,
    @required Function no,
     }){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: Text(message) ,
          actions: <Widget>[
            RaisedButton(
              child: Text('YES',style: TextStyle(color: Colors.white),),
              color: Colors. green,
              onPressed: yes,
            ),
            RaisedButton(
              child: Text('NO',style: TextStyle(color: Colors.white),),
              color: Colors. green,
              onPressed: no,
            ),
          ],
        );
        
      },
    );
  }

  //Progress bar dialog
  static void showProgressBar(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => 
        Center (child: CircularProgressIndicator()),
    );
  }

  //Dispose Progress bar
  static void popProgressBar(BuildContext context){
    Navigator.pop(context);     
  }
}