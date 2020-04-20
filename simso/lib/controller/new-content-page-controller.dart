import 'package:flutter/material.dart';
import 'package:simso/model/entities/song-model.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/model/entities/thought-model.dart';
import 'package:simso/model/services/imeme-service.dart';
import 'package:simso/model/services/ipicture-service.dart';
import 'package:simso/model/services/isong-service.dart';
import 'package:simso/model/services/ithought-service.dart';
import 'package:simso/model/services/iuser-service.dart';
import 'package:simso/service-locator.dart';
import 'package:simso/view/music-feed.dart';
import 'package:simso/view/new-content.dart';
import 'package:simso/view/profile-page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';

class NewContentPageController {
  AudioPlayer audioPlayer = new AudioPlayer(playerId: null);
  NewContentPageState state;
  NewContentPageController(this.state);
  int result;

  final ISongService songService = locator<ISongService>();
  final IUserService userService = locator<IUserService>();
  final IMemeService memeService = locator<IMemeService>();
  final IImageService imageService = locator<IImageService>();
  final IThoughtService thoughtService = locator<IThoughtService>();

  void snapshots() async {
    state.memesList = [];
    state.publicThoughtsList = [];
    state.imageList =
        await imageService.contentSnaps(state.friends, state.user);
    if (state.snapshots == false) {
      state.meme = false;
      state.thoughts = false;
      state.music = false;
      state.snapshots = true;
      state.stateChanged(() {});
    }
  }

  Future music() async {
    print("GOTHERE");
    state.memesList = [];
    state.imageList = [];
    state.allSongsList =
        await songService.contentSongList(state.friends, state.user);
    state.allUsersList = await userService.readAllUser();
    if (state.music == false) {
      state.stateChanged(() {
        state.meme = false;
        state.thoughts = false;
        state.music = true;
        state.snapshots = false;
      });
    }
    state.stateChanged(() {});
  }

  void thoughts() async {
    state.memesList = [];
    state.imageList = [];
    state.publicThoughtsList =
        await thoughtService.contentThoughtList(state.friends, state.user);

    for (Thought thought in state.publicThoughtsList) {
      thought.text = await thoughtService.translateThought(
          state.user.language, thought.text);
    }

    if (state.thoughts == false) {
      state.meme = false;
      state.thoughts = true;
      state.music = false;
      state.snapshots = false;
      state.stateChanged(() {});
    }
    state.stateChanged(() {});
  }

  void meme() async {
    state.publicThoughtsList = [];
    state.imageList = [];
    state.memesList =
        await memeService.contentMemeList(state.friends, state.user);
    if (state.meme == false) {
      state.meme = true;
      state.thoughts = false;
      state.music = false;
      state.snapshots = false;
      state.stateChanged(() {});
    }
  }

  Future playFunc(String songUrl) async {
    var uuid = Uuid();

    playSong() async {
      try {
        result = await audioPlayer.play(songUrl);
        if (result == 1) {
          print("============== Play Success");
        } else {
          print("============== Play Failed");
        }
      } catch (e) {
        print("Play Error: " + e.toString());
      }
    }

    stopSong() async {
      try {
        result = await audioPlayer.stop();
        if (result == 1) {
          print("============== Stop Success");
        } else {
          print("============== Stop Failed");
        }
      } catch (e) {
        print("Stop Song Error: " + e.toString());
      }
    }

    if (state.play == false && state.pause == true) {
      if (state.playerId == "") {
        audioPlayer = new AudioPlayer(playerId: uuid.v4());
        //print("============= 1st playerId: " + audioPlayer.playerId.toString());
        state.stateChanged(() {
          state.tempSongUrl = songUrl;
          state.playerId = audioPlayer.playerId;
        });
        playSong();
        state.stateChanged(() {
          state.play = true;
          state.pause = false;
        });
      } else {
        playSong();
        state.stateChanged(() {
          state.play = true;
          state.pause = false;
        });
      }
    }

    if (state.play == true &&
        state.pause == false &&
        songUrl != state.tempSongUrl) {
      await stopSong();
      state.stateChanged(() {
        //print("************* PLAY NEW SONG FRM PAUSE **************");
        audioPlayer = new AudioPlayer(playerId: uuid.v4());
        // print("============= Subsequent new playerId: " +
        //     audioPlayer.playerId.toString());

        state.play = true;
        state.pause = false;
        state.tempSongUrl = songUrl;
        state.playerId = audioPlayer.playerId;
        playSong();
      });
    }
  }

  Future pauseFunc(String songUrl) async {
    var uuid = Uuid();

    playSong() async {
      try {
        result = await audioPlayer.play(songUrl);
        if (result == 1) {
          print("============== Play Success");
        } else {
          print("============== Play Failed");
        }
      } catch (e) {
        print("Play Error: " + e.toString());
      }
    }

    stopSong() async {
      try {
        result = await audioPlayer.stop();
        if (result == 1) {
          print("============== Stop Success");
        } else {
          print("============== Stop Failed");
        }
      } catch (e) {
        print("Stop Song Error: " + e.toString());
      }
    }

    pauseSong() async {
      try {
        result = await audioPlayer.pause();
        if (result == 1) {
          print("============== Pause Success");
        } else {
          print("============== Pause Failed");
        }
      } catch (e) {
        print("Pause Error: " + e.toString());
      }
    }

    if (state.play == true && state.pause == false) {
      if (songUrl != state.tempSongUrl) {
        //print("************* PLAY NEW SONG FRM PLAY **************");
        await stopSong();
        state.stateChanged(() {
          audioPlayer = new AudioPlayer(playerId: uuid.v4());
          // print("============= Subsequent new playerId: " +
          //     audioPlayer.playerId.toString());
          //pause = true;
          state.play = true;
          state.pause = false;
          state.tempSongUrl = songUrl;
          state.playerId = audioPlayer.playerId;
          playSong();
        });
      } else {
        pauseSong();
        state.stateChanged(() {
          state.pause = true;
          state.play = false;
        });
      }
    }
  }
}
