import 'package:flutter/cupertino.dart';
import 'package:simso/view/choose-avatar.dart';

class ChooseAvatarController{
  ChooseAvatarState state;
  ChooseAvatarController(this.state);

  void angryBird() {
    Navigator.pop(state.context, state.angryBird);
  }

  void fire() {
    Navigator.pop(state.context, state.fire);
  }

  void earthBackground() {
    Navigator.pop(state.context, state.earthBackground);
  }

  void hackerFace() {
    Navigator.pop(state.context, state.hackerFace);
  }

  void moonBackground() {
    Navigator.pop(state.context, state.moonBackground);
  }

  void ninja() {
    Navigator.pop(state.context, state.ninja);
  }
}