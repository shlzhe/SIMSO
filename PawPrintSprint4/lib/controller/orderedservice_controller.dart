

import 'package:PawPrint/controller/myfirebase.dart';
import 'package:PawPrint/view/orderedservice.dart';

class OrderedServiceController{
  OrderedServiceState state;
  OrderedServiceController(this.state);

  onTap(int index) {
    if (state.deleteIndices == null) {

    }else{
      //add to delete list
      if (state.deleteIndices.contains(index)){
        //tapped again deselect
        state.deleteIndices.remove(index);
        if (state.deleteIndices.length == 0){
          //all deselected. delete mode quits
          state.deleteIndices = null;
          state.deleteMode=false;
        }
      }else{
        state.deleteIndices.add(index);
      }
      state.stateChanged((){});
    }
  }
  onLongPress(int index) {
    if (state.deleteIndices == null) {
      // state.deleteIndices = <int>[index];
      state.stateChanged(() {
        state.deleteIndices = <int>[index];
        state.deleteMode=true;
      });
    }
  }

  void delete() {
    state.deleteIndices.sort((n1,n2){
      if (n1 < n2) return 1;
      else if (n1 == n2)return 0;
      else return -1;
    });
    for (var i in state.deleteIndices){
      print(state.orderService[i].dateTime);
      MyFirebase.deleteOrder(state.orderService[i], state.user);
      state.orderService.removeLast();
    }
    state.stateChanged((){
      state.deleteMode=false;
      state.deleteIndices.clear();
      state.deleteIndices = null;
    });
  }
}