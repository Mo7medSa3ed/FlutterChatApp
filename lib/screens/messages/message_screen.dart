import 'package:chat/constants.dart';
import 'package:chat/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';

class MessagesScreen extends StatelessWidget {
  final chatUser;
  final roomId;
  MessagesScreen(this.chatUser, this.roomId);
  var idx = -1;
  openRoom(context, value) {
    final pro = Provider.of<AppProvider>(context, listen: false);
    idx = pro.roomList!.indexWhere((e) => e.id == roomId);
    if (idx != -1) {
      pro.roomList![idx].isOpen = value;
      pro.roomList![idx].msgCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    openRoom(context, true);
    return WillPopScope(
      onWillPop: () {
        idx = provider.roomList!.indexWhere((e) => e.id == roomId);
        if (idx != -1) {
          provider.roomList![idx].isOpen = false;
        }

        return Future.value(true);
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Body(
          roomId,
          chatUser.id,
        ),
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
              chatUser.online
                  ? Consumer<AppProvider>(
                      builder: (ctx, app, w) => Text(
                           app.roomList![0].recieverStatus??'' ,
                            style: TextStyle(fontSize: 12),
                          ))
                  : Text(
                      "Last seen ${chatUser.lastSeen}",
                      style: TextStyle(fontSize: 12),
                    )
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
