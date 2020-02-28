import 'package:flutter/material.dart';
import 'package:simso/view/design-constants.dart';
import '../controller/snapshot-page-controller.dart';

class SnapshotPage extends StatefulWidget {
  SnapshotPage();

  @override
  State<StatefulWidget> createState() {
    return SnapshotPageState();
  }
}

class SnapshotPageState extends State<SnapshotPage> {
  SnapshotPageController controller;
  BuildContext context;

  SnapshotPageState() {
    controller = SnapshotPageController(this);
  }

  void stateChanged(Function fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Snapshots'),
        backgroundColor: DesignConstants.blueGreyish,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: buildPost(),
      ),
    );
  }
}

  buildPost() {
    // if (postData != null) {
    //   return ListView(
    //     children: postData,
    //   );
    // } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    //}
  }

Future<Null> _refresh() async {

  return;
}
