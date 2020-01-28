import 'package:PawPrint/controller/petprofilelist_controller.dart';
import 'package:PawPrint/model/pet.dart';
import 'package:PawPrint/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PetProfilePage extends StatefulWidget{
  final bool sharedmode;
  final User user;
  final List<Pet> petList;
  PetProfilePage(this.user, this.petList, this.sharedmode);
  @override
  State<StatefulWidget> createState() {
    return PetProfileListState(user, petList, sharedmode);
      }
    
    }
    
    class PetProfileListState extends State<PetProfilePage>{
      bool sharedmode;
      User user;
      List<Pet> petList;
      List<int> deleteIndices;
      bool deleteMode=false;
      BuildContext context;
      PetProfileListController controller;
      PetProfileListState(this.user, this.petList, this.sharedmode){
        controller = PetProfileListController(this);
      }

    void stateChanged(Function f){
      setState(f);
    }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Profile Collection',style: TextStyle(fontSize: 30,fontFamily: 'Modak'),),
          backgroundColor: Colors.green,
        actions: 
          deleteMode == true ? <Widget>[
          FlatButton.icon(
            label: Text('Delete'),
            icon: Icon(Icons.delete_forever),
            onPressed: controller.delete,
          )] : null,
        
      ),
      floatingActionButton: sharedmode == true ? null : FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.pets, color: Colors.white,),
        onPressed: controller.addPet,
      ),
      body: ListView.builder(
          itemCount: petList.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              padding: EdgeInsets.all(5.0),
              color: deleteIndices != null && deleteIndices.contains(index) ?
                  Colors.cyan : Colors.white,
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: petList[index].petPic,
                  placeholder: (context, url)=>CircularProgressIndicator(),
                  errorWidget: (context, url, error)=>Icon(Icons.error_outline),
                ),
                title: Text('Name: '+petList[index].petName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Age: '+petList[index].petAge.toString()),
                    Text('Owner: '+petList[index].petOwner),
                  ],
                ),
                onTap: ()=>controller.onTap(index),
                onLongPress: ()=>controller.onLongPress(index),
              ),
            );
          },
        ),
    );
  }
}