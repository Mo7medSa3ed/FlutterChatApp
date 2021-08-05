import 'package:chat/constants.dart';
import 'package:chat/models/User.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class MessagesScreen extends StatelessWidget {
  User chatUser;
  final roomId;
  MessagesScreen(this.chatUser, this.roomId);
  int idx = -1;
  var pro;

  openRoom(context, value) {
    if (roomId != null) {
      idx = pro.roomList!.indexWhere((e) => e.id == roomId);
      if (idx != -1) {
        pro.roomList![idx].isOpen = value;
        pro.roomList![idx].msgCount = 0;

        if (chatUser.id == null) {
          chatUser = pro.roomList![idx].reciverId;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    pro = Provider.of<AppProvider>(context, listen: false);
    openRoom(context, true);
    return WillPopScope(
      onWillPop: () {
        idx = pro.roomList!.indexWhere((e) => e.id == roomId);
        if (idx != -1) {
          pro.roomList![idx].isOpen = false;
        }

        return Future.value(true);
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Body(roomId, chatUser.id, chatUser.img ?? img),
      ),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(
            onPressed: () {
              openRoom(context, false);
              Navigator.of(context).pop();
            },
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(chatUser.img ?? img),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatUser.name ?? '',
                style: TextStyle(fontSize: 16),
              ),
              Consumer<AppProvider>(builder: (ctx, app, w) {
                if (app.chatList.length > 0 && idx == -1) {
                  final rid = app.chatList[0].roomId;
                  idx = pro.roomList!.indexWhere((e) => e.id == rid);
                  if (idx != -1) {
                    pro.roomList![idx].isOpen = true;
                    pro.roomList![idx].msgCount = 0;
                  }
                }

                return chatUser.online ?? false
                    ? Text(
                        app.roomList!.length > 0
                            ? app.roomList![idx].recieverStatus != null
                                ? app.roomList![idx].recieverStatus!
                                : "online"
                            : "",
                        style: TextStyle(fontSize: 12),
                      )
                    : Text(
                        "Last seen ${dateTimeFormat(chatUser.lastSeen)} ",
                        style: TextStyle(fontSize: 12),
                      );
              })
            ],
          )
        ],
      ),
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.local_phone),
      //     onPressed: () {},
      //   ),
      //   IconButton(
      //     icon: Icon(Icons.videocam),
      //     onPressed: () {},
      //   ),
      //   SizedBox(width: kDefaultPadding / 2),
      // ],
    );
  }
}
