import 'package:flutter/material.dart';

class MyDialog {
  static void info(
      {@required BuildContext context,
      @required String title,
      @required String message,
      @required Function action}) {
    // String url ='https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.123rf.com%2Fphoto_57080070_stock-vector-cross-sign-element-red-x-icon-isolated-on-white-background-simple-mark-graphic-design-round-shape-bu.html&psig=AOvVaw2zN0v2RYRhacD-bCC5FxCw&ust=1581215815261000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCOjYhaH2wOcCFQAAAAAdAAAAABAE';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
          height: 120,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.error,
                  size: 50,
                  color: Colors.blue,
                ),
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
              onPressed: action,
            ),
          ],
        );
      },
    );
  }

  //Progress bar dialog
  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }

  //Dispose Progress bar
  static void popProgressBar(BuildContext context) {
    Navigator.pop(context);
  }
}
