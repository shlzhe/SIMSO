import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simso/controller/choose-avatar-controller.dart';
import 'package:simso/view/design-constants.dart';

class ChooseAvatar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ChooseAvatarState();
      }
    
    }
    
    class ChooseAvatarState extends State<ChooseAvatar> {
      BuildContext context;
      ChooseAvatarController controller;
      String angryBird = 'https://firebasestorage.googleapis.com/v0/b/capstone-16d44.appspot.com/o/ApplicationImages%2FAngry%20bird.png?alt=media&token=a55f8978-55a6-40c0-bf48-83f041dc9d47';
      String fire = 'https://firebasestorage.googleapis.com/v0/b/capstone-16d44.appspot.com/o/ApplicationImages%2FFire.jpg?alt=media&token=70e36ace-443f-4b83-ab36-e060bb432ca6';
      String earthBackground = 'https://firebasestorage.googleapis.com/v0/b/capstone-16d44.appspot.com/o/ApplicationImages%2Fearth.png?alt=media&token=5879c82a-d2e7-473e-a9d8-66778d664272';
      String hackerFace ='https://firebasestorage.googleapis.com/v0/b/capstone-16d44.appspot.com/o/ApplicationImages%2Fhackerface.jfif?alt=media&token=74f17605-39ab-4fba-8dab-9f13fd36d152';
      String moonBackground = 'https://firebasestorage.googleapis.com/v0/b/capstone-16d44.appspot.com/o/ApplicationImages%2Fmoon.png?alt=media&token=f5fe47b9-943e-4344-aa6b-a4ccbe7dae85';
      String ninja = 'https://firebasestorage.googleapis.com/v0/b/capstone-16d44.appspot.com/o/ApplicationImages%2Fninja.jpg?alt=media&token=509c23bc-cffc-4b20-bc6b-8e2f23fd7f31';
      ChooseAvatarState(){
        controller = ChooseAvatarController(this);
      }
  @override
  Widget build(BuildContext context) {
    this.context =context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose an Avatar', style: TextStyle(color: DesignConstants.yellow),),
        backgroundColor: DesignConstants.blue,
      ),
      body: Container(
        color: DesignConstants.blueLight,
        child: ListView(
          children: <Widget>[
            Text('Angry bird:', style: TextStyle(color: DesignConstants.yellow, fontSize: 30),),
            FlatButton.icon(
              onPressed: controller.angryBird, 
              icon: Image.network(angryBird,scale: 3,), 
              label: Text(''),
            ),
            Text('Fire:', style: TextStyle(color: DesignConstants.yellow, fontSize: 30),),
            FlatButton.icon(
              onPressed: controller.fire, 
              icon: Image.network(fire,scale: 3,), 
              label: Text(''),
            ),
            Text('Earth background:', style: TextStyle(color: DesignConstants.yellow, fontSize: 30),),
            FlatButton.icon(
                onPressed: controller.earthBackground, 
                icon: Image.network(earthBackground,scale: 3,), 
                label: Text(''),
              ),
              Text('Hacker face:', style: TextStyle(color: DesignConstants.yellow, fontSize: 30),),
            FlatButton.icon(
              onPressed: controller.hackerFace, 
              icon: Image.network(hackerFace,scale: 3,), 
              label: Text(''),
            ),
            Text('Moon background:', style: TextStyle(color: DesignConstants.yellow, fontSize: 30),),
            FlatButton.icon(
              onPressed: controller.moonBackground, 
              icon: Image.network(moonBackground,scale: 3,), 
              label: Text(''),
            ),
            Text('Ninja:', style: TextStyle(color: DesignConstants.yellow, fontSize: 30),),
            FlatButton.icon(
              onPressed: controller.ninja, 
              icon: Image.network(ninja,scale: 3,), 
              label: Text(''),
            ),
            // FlatButton.icon(
            //   onPressed: controller.angryBird, 
            //   icon: Image.network('',scale: 3,), 
            //   label: Text('', style: TextStyle(color: DesignConstants.yellow, fontSize: 40),)
            // ),
          ],
        ),
      ),
    );
  }
}