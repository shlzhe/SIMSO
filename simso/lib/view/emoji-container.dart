import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simso/model/entities/message-model.dart';
import 'package:simso/model/services/imessage-service.dart';
import '../model/entities/user-model.dart';
import '../service-locator.dart';

class EmojiContainer extends StatelessWidget {
  final UserModel user;
  final String postedByUid;
  final BuildContext context;
  final int mediaType;
  final String mediaUid;
  final IMessageService messageService = locator<IMessageService>();

  emojiClicked() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget> [EmojiPicker(
            rows: 3,
            columns: 7,
            numRecommended: 10,
            onEmojiSelected: (emoji, category) {
              print(emoji.toString());
              sendEmoji(emoji.emoji);
              Navigator.pop(context);
            },
          ),]
        );
      }
    );
  }

  sendEmoji(String emoji) async {
    var messages = await messageService.getFilteredMessages(user.uid, postedByUid);
    var count = 1;
    var mediaString = mediaTypes.values[mediaType];
    if (messages.length > 0)
      count = messages.length + 1;
    var message = Message (
      isLike: false,
      receiver: this.postedByUid,
      counter: count,
      sender: this.user.uid,
      text: '${user.username} reacted to your ${mediaString.toString().substring(mediaString.toString().indexOf('.')+1)}: $emoji',
      time:  DateFormat('MM-dd-yyyy - HH:mm:ss').format(DateTime.now()),
      unread: true
    );

    print(emoji + ' Clicked');

    await messageService.addMessage(message);
  }

  EmojiContainer(this.context, this.user, this.mediaType, this.mediaUid, this.postedByUid);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text('❤️', style: TextStyle(fontSize: 20),),
        onPressed: () { emojiClicked(); },
      )
    );
  }
}

enum mediaTypes {
  thought,
  snapshot,
  meme,
  music
}