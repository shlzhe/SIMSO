import 'package:flutter/material.dart';
import '../view/profile-page.dart';
import '../view/account-setting-page.dart';
import '../model/entities/song-model.dart';
import '../model/services/isong-service.dart';
import '../service-locator.dart';
import '../view/my-music-page.dart';
import '../model/entities/globals.dart' as globals;
import '../view/limit-reached-dialog.dart';



class ProfilePageController {
final ISongService _songService = locator<ISongService>();

  ProfilePageState state;
  ProfilePageController(this.state);

  void accountSettings() async {
    Navigator.push(
        state.context,
        MaterialPageRoute(
            builder: (context) => AccountSettingPage(
                  state.user,
                )));
  }

  Future mymusic() async {
    List<SongModel> songlist;
    try {
      print("GET SONGS");
      songlist = await _songService.getSong(state.user.email);
    } catch (e) {
      songlist = <SongModel>[];
      print("SONGLIST LENGTH: " + songlist.length.toString());
    }
    print("SUCCEED IN GETTING SONGS");
    Navigator.push(
      state.context,
      MaterialPageRoute(
        builder: (context) => MyMusic(state.user, songlist),
      ),
    );
    checkLimits();
  }

  void checkLimits() async {
    var timeLimitReached = (globals
                .getDate(globals.limit.overrideThruDate)
                .difference(DateTime.now())
                .inDays !=
            0 &&
        globals.timer.timeOnAppSec / 60 > globals.limit.timeLimitMin);
    var touchLimitReached = (globals
                .getDate(globals.limit.overrideThruDate)
                .difference(DateTime.now())
                .inDays !=
            0 &&
        globals.touchCounter.touches > globals.limit.touchLimit);

    if ((timeLimitReached && globals.limit.timeLimitMin > 0) ||
        (touchLimitReached && globals.limit.touchLimit > 0)) {
      LimitReachedDialog.info(
          context: state.context,
          user: state.user,
          timeReached: timeLimitReached);
      print('Limit Dialog opened');
    }
  }
}
