import 'package:simso/model/services/ithought-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
import 'package:simso/view/new-content.dart';

class NewContentPageController{
  NewContentPageState state;
  NewContentPageController(this.state);
  
  IUserService userService = locator<IUserService>();
  final IThoughtService thoughtService = locator<IThoughtService>();
  void snapshots() {
    if (state.snapshots == false){
      state.meme = false;
      state.thoughts = false;
      state.music = false;
      state.snapshots = true;
      state.stateChanged((){});
    }
  }

  void music() {
    if (state.music == false){
      state.stateChanged((){
        state.meme = false;
        state.thoughts = false;
        state.music = true;
        state.snapshots = false;
      });
    }
  }

  void thoughts() async {
    state.publicThoughtsList = await thoughtService.contentThoughtList(state.friends, state.user.friends, state.user.language);
    if (state.thoughts == false){
      state.meme = false;
      state.thoughts = true;
      state.music = false;
      state.snapshots = false;
      state.stateChanged((){});
    }
    state.stateChanged((){});
  }

  void meme() {
    if (state.meme == false){
      state.meme = true;
      state.thoughts = false;
      state.music = false;
      state.snapshots = false;
      state.stateChanged((){});
    }
  }
}