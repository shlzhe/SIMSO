import 'package:flutter/material.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/services/imeme-service.dart';
import 'package:simso/model/services/ipicture-service.dart';
import 'package:simso/model/services/isong-service.dart';
import 'package:simso/model/services/ithought-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
import 'package:simso/view/music-feed.dart';
import 'package:simso/view/new-content.dart';
import 'package:simso/view/profile-page.dart';
import 'package:simso/model/entities/thought-model.dart';

class NewContentPageController{
  NewContentPageState state;
  NewContentPageController(this.state);
  
  final ISongService songService = locator<ISongService>();
  final IUserService userService = locator<IUserService>();
  final IMemeService memeService = locator<IMemeService>();
  final IImageService imageService = locator<IImageService>();
  final IThoughtService thoughtService = locator<IThoughtService>();

  void snapshots() async{
    state.memesList=[];
    state.publicThoughtsList = [];
    state.imageList = await imageService.contentSnaps(state.friends, state.user);
    if (state.snapshots == false){
      state.meme = false;
      state.thoughts = false;
      state.music = false;
      state.snapshots = true;
      state.stateChanged((){});
    }
  }

  Future music() async {
    if (state.music == false){
      state.stateChanged((){
        state.meme = false;
        state.thoughts = false;
        state.music = true;
        state.snapshots = false;
      });
    }
   List<SongModel> allSongList;
    List<UserModel> allUserList;
    try {
      print("GET SONGS & USERS");
      allSongList = await songService.getAllSongList();
      allUserList = await userService.readAllUser();
    } catch (e) {
      allSongList = <SongModel>[];

      print("SONGLIST LENGTH: " + allSongList.length.toString());
    }
    print("SUCCEED IN GETTING SONGS & USERS");
    Navigator.push(
      state.context,
      MaterialPageRoute(
        builder: (context) => MusicFeed(
          state.user,
          allUserList,
          allSongList,
        ),
      ),
    );
  }

  void thoughts() async {
    state.memesList=[];
    state.imageList = [];
    state.publicThoughtsList = await thoughtService.contentThoughtList(state.friends, state.user);

      for(Thought thought in state.publicThoughtsList){
        thought.text = await thoughtService.translateThought(state.user.language, thought.text);
    }


    if (state.thoughts == false){
      state.meme = false;
      state.thoughts = true;
      state.music = false;
      state.snapshots = false;
      state.stateChanged((){});
    }
    state.stateChanged((){});
  }

  void meme() async{
    state.publicThoughtsList = [];
    state.imageList = [];
    state.memesList = await memeService.contentMemeList(state.friends, state.user);
    if (state.meme == false){
      state.meme = true;
      state.thoughts = false;
      state.music = false;
      state.snapshots = false;
      state.stateChanged((){});
    }
  }
}